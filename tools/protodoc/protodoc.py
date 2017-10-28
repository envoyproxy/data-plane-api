# protoc plugin to map from FileDescriptorProtos to Envoy doc style RST.
# See https://github.com/google/protobuf/blob/master/src/google/protobuf/descriptor.proto
# for the underlying protos mentioned in this file. See
# http://www.sphinx-doc.org/en/stable/rest.html for Sphinx RST syntax.

from collections import defaultdict
import copy
import functools
import sys

from google.protobuf.compiler import plugin_pb2

# Namespace prefix for Envoy APIs.
ENVOY_API_NAMESPACE_PREFIX = '.envoy.api.v2.'

# Namespace prefix for WKTs.
WKT_NAMESPACE_PREFIX = '.google.protobuf.'

# http://www.fileformat.info/info/unicode/char/2063/index.htm
UNICODE_INVISIBLE_SEPARATOR = u'\u2063'


class ProtodocError(Exception):
  """Base error class for the protodoc module."""


class SourceCodeInfo(object):
  """Wrapper for SourceCodeInfo proto."""

  def __init__(self, source_code_info):
    self._proto = source_code_info

  @property
  def file_level_comment(self):
    """Obtain inferred file level comment."""
    comment = ''
    earliest_detached_comment = max(
        max(location.span) for location in self._proto.location)
    for location in self._proto.location:
      if location.leading_detached_comments and location.span[0] < earliest_detached_comment:
        comment = StripLeadingSpace(''.join(
            location.leading_detached_comments)) + '\n'
        earliest_detached_comment = location.span[0]
    return comment

  def LeadingCommentPathLookup(self, path):
    """Lookup leading comment by path in SourceCodeInfo.

    Args:
      path: a list of path indexes as per
        https://github.com/google/protobuf/blob/a08b03d4c00a5793b88b494f672513f6ad46a681/src/google/protobuf/descriptor.proto#L717.
    Returns:
      Attached leading comment if it exists, otherwise empty space.
    """
    for location in self._proto.location:
      if location.path == path:
        return StripLeadingSpace(location.leading_comments) + '\n'
    return ''


class TypeContext(object):
  """Contextual information for a message/field.

  Provides information around namespaces and enclosing types for fields and
  nested messages/enums.
  """

  def __init__(self, source_code_info, path, name):
    # SourceCodeInfo as per
    # https://github.com/google/protobuf/blob/a08b03d4c00a5793b88b494f672513f6ad46a681/src/google/protobuf/descriptor.proto.
    self.source_code_info = source_code_info
    # path: a list of path indexes as per
    #  https://github.com/google/protobuf/blob/a08b03d4c00a5793b88b494f672513f6ad46a681/src/google/protobuf/descriptor.proto#L717.
    #  Extended as nested objects are traversed.
    self.path = path
    # Message/enum/field name. Extended as nested objects are traversed.
    self.name = name
    # Map from type name to the correct type annotation string, e.g. from
    # ".envoy.api.v2.Foo.Bar" to "map<string, string>". This is lost during
    # proto synthesis and is dynamically recovered in FormatMessage.
    self.map_typenames = {}
    # Map from a message's oneof index to the fields sharing a oneof.
    self.oneof_fields = {}

  def Extend(self, path, name):
    extended = copy.deepcopy(self)
    extended.path.extend(path)
    extended.name = '%s.%s' % (self.name, name)
    return extended

  def LeadingCommentPathLookup(self):
    return self.source_code_info.LeadingCommentPathLookup(self.path)


def MapLines(f, s):
  """Apply a function across each line in a flat string.

  Args:
    f: A string transform function for a line.
    s: A string consisting of potentially multiple lines.
  Returns:
    A flat string with f applied to each line.
  """
  return '\n'.join(f(line) for line in s.split('\n'))


def Indent(spaces, line):
  """Indent a string."""
  return ' ' * spaces + line


def IndentLines(spaces, lines):
  """Indent a list of strings."""
  return map(functools.partial(Indent, spaces), lines)


def FormatInternalLink(text, ref):
  return ':ref:`%s <%s>`' % (text, ref)


def FormatExternalLink(text, ref):
  return '`%s <%s>`_' % (text, ref)


def FormatHeader(style, text):
  """Format RST header.

  Args:
    style: underline style, e.g. '=', '-'.
    text: header text
  Returns:
    RST formatted header.
  """
  return '%s\n%s\n\n' % (text, style * len(text))


def FormatFieldTypeAsJson(type_context, field):
  """Format FieldDescriptorProto.Type as a pseudo-JSON string.

  Args:
    type_context: contextual information for message/enum/field.
    field: FieldDescriptor proto.
  Return:
    RST formatted pseudo-JSON string representation of field type.
  """
  if NormalizeFQN(field.type_name) in type_context.map_typenames:
    return '"{...}"'
  if field.label == field.LABEL_REPEATED:
    return '[]'
  if field.type == field.TYPE_MESSAGE:
    return '"{...}"'
  return '"..."'


def FormatMessageAsJson(type_context, msg):
  """Format a message definition DescriptorProto as a pseudo-JSON block.

  Args:
    type_context: contextual information for message/enum/field.
    msg: message definition DescriptorProto.
  Return:
    RST formatted pseudo-JSON string representation of message definition.
  """
  lines = [
      '"%s": %s' % (f.name, FormatFieldTypeAsJson(type_context, f))
      for f in msg.field
  ]
  return '.. code-block:: json\n\n  {\n' + ',\n'.join(IndentLines(
      4, lines)) + '\n  }\n\n'


def NormalizeFQN(fqn):
  """Normalize a fully qualified field type name.

  Strips leading ENVOY_API_NAMESPACE_PREFIX and makes pretty wrapped type names.

  Args:
    fqn: a fully qualified type name from FieldDescriptorProto.type_name.
  Return:
    Normalized type name.
  """
  if fqn.startswith(ENVOY_API_NAMESPACE_PREFIX):
    return fqn[len(ENVOY_API_NAMESPACE_PREFIX):]
  return fqn


def FormatEmph(s):
  """RST format a string for emphasis."""
  return '*%s*' % s


def FormatFieldType(type_context, field):
  """Format a FieldDescriptorProto type description.

  Adds cross-refs for message types.
  TODO(htuch): Add cross-refs for enums as well.

  Args:
    type_context: contextual information for message/enum/field.
    field: FieldDescriptor proto.
  Return:
    RST formatted field type.
  """
  if field.type_name.startswith(ENVOY_API_NAMESPACE_PREFIX):
    type_name = NormalizeFQN(field.type_name)
    if field.type == field.TYPE_MESSAGE:
      if type_context.map_typenames and type_name in type_context.map_typenames:
        return type_context.map_typenames[type_name]
      return FormatInternalLink(type_name, MessageCrossRefLabel(type_name))
    if field.type == field.TYPE_ENUM:
      return FormatInternalLink(type_name, EnumCrossRefLabel(type_name))
  elif field.type_name.startswith(WKT_NAMESPACE_PREFIX):
    wkt = field.type_name[len(WKT_NAMESPACE_PREFIX):]
    return FormatExternalLink(
        wkt,
        'https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#%s'
        % wkt.lower())
  elif field.type_name:
    return field.type_name

  pretty_type_names = {
      field.TYPE_DOUBLE: 'double',
      field.TYPE_FLOAT: 'float',
      field.TYPE_INT32: 'int32',
      field.TYPE_UINT32: 'uint32',
      field.TYPE_INT64: 'int64',
      field.TYPE_UINT64: 'uint64',
      field.TYPE_BOOL: 'bool',
      field.TYPE_STRING: 'string',
      field.TYPE_BYTES: 'bytes',
  }
  if field.type in pretty_type_names:
    return FormatExternalLink(
        pretty_type_names[field.type],
        'https://developers.google.com/protocol-buffers/docs/proto#scalar')
  raise ProtodocError('Unknown field type ' + str(field.type))


def StripLeadingSpace(s):
  """Remove leading space in flat comment strings."""
  return MapLines(lambda s: s[1:], s)


def MessageCrossRefLabel(msg_name):
  """Message cross reference label."""
  return 'envoy_api_msg_%s' % msg_name


def EnumCrossRefLabel(enum_name):
  """Enum cross reference label."""
  return 'envoy_api_enum_%s' % enum_name


def FieldCrossRefLabel(field_name):
  """Field cross reference label."""
  return 'envoy_api_field_%s' % field_name


def EnumValueCrossRefLabel(enum_value_name):
  """Enum value cross reference label."""
  return 'envoy_api_enum_value_%s' % enum_value_name


def FormatAnchor(label):
  """Format a label as an Envoy API RST anchor."""
  return '.. _%s:\n\n' % label


def FormatFieldAsDefinitionListItem(type_context, field):
  """Format a FieldDescriptorProto as RST definition list item.

  Args:
    type_context: contextual information for message/enum/field.
    field: FieldDescriptorProto.
  Returns:
    RST formatted definition list item.
  """
  if field.HasField('oneof_index'):
    oneof_comment = '\nOnly one of %s may be set.\n' % ', '.join(
        type_context.oneof_fields[field.oneof_index])
  else:
    oneof_comment = ''
  anchor = FormatAnchor(FieldCrossRefLabel(type_context.name))
  comment = '(%s) ' % FormatFieldType(
      type_context, field) + type_context.LeadingCommentPathLookup()
  return anchor + field.name + '\n' + MapLines(
      functools.partial(Indent, 2), comment + oneof_comment)


def FormatMessageAsDefinitionList(type_context, msg):
  """Format a DescriptorProto as RST definition list.

  Args:
    type_context: contextual information for message/enum/field.
    msg: DescriptorProto.
  Returns:
    RST formatted definition list item.
  """
  type_context.oneof_fields = defaultdict(list)
  for field in msg.field:
    if field.HasField('oneof_index'):
      type_context.oneof_fields[field.oneof_index].append(field.name)
  return '\n'.join(
      FormatFieldAsDefinitionListItem(
          type_context.Extend([2, index], field.name), field)
      for index, field in enumerate(msg.field)) + '\n'


def FormatMessage(type_context, msg):
  """Format a DescriptorProto as RST section.

  Args:
    type_context: contextual information for message/enum/field.
    msg: DescriptorProto.
  Returns:
    RST formatted section.
  """
  # Skip messages synthesized to represent map types.
  if msg.options.map_entry:
    return ''
  # We need to do some extra work to recover the map type annotation from the
  # synthesized messages.
  type_context.map_typenames = {
      '%s.%s' % (type_context.name, nested_msg.name): 'map<%s, %s>' % tuple(
          map(
              functools.partial(FormatFieldType, type_context),
              nested_msg.field))
      for nested_msg in msg.nested_type if nested_msg.options.map_entry
  }
  nested_msgs = '\n'.join(
      FormatMessage(
          type_context.Extend([3, index], nested_msg.name), nested_msg)
      for index, nested_msg in enumerate(msg.nested_type))
  nested_enums = '\n'.join(
      FormatEnum(
          type_context.Extend([4, index], nested_enum.name), nested_enum)
      for index, nested_enum in enumerate(msg.enum_type))
  anchor = FormatAnchor(MessageCrossRefLabel(type_context.name))
  header = FormatHeader('-', type_context.name)
  comment = type_context.LeadingCommentPathLookup()
  return anchor + header + comment + FormatMessageAsJson(
      type_context, msg) + FormatMessageAsDefinitionList(
          type_context, msg) + nested_msgs + '\n' + nested_enums


def FormatEnumValueAsDefinitionListItem(type_context, enum_value):
  """Format a EnumValueDescriptorProto as RST definition list item.

  Args:
    type_context: contextual information for message/enum/field.
    enum_value: EnumValueDescriptorProto.
  Returns:
    RST formatted definition list item.
  """
  anchor = FormatAnchor(EnumValueCrossRefLabel(type_context.name))
  default_comment = '*(DEFAULT)* ' if enum_value.number == 0 else ''
  comment = default_comment + UNICODE_INVISIBLE_SEPARATOR + type_context.LeadingCommentPathLookup(
  )
  return anchor + '%s (%d)' % (enum_value.name,
                               enum_value.number) + '\n' + MapLines(
                                   functools.partial(Indent, 2), comment)


def FormatEnumAsDefinitionList(type_context, enum):
  """Format a EnumDescriptorProto as RST definition list.

  Args:
    type_context: contextual information for message/enum/field.
    enum: DescriptorProto.
  Returns:
    RST formatted definition list item.
  """
  return '\n'.join(
      FormatEnumValueAsDefinitionListItem(
          type_context.Extend([2, index], enum_value.name), enum_value)
      for index, enum_value in enumerate(enum.value)) + '\n'


def FormatEnum(type_context, enum):
  """Format an EnumDescriptorProto as RST section.

  Args:
    type_context: contextual information for message/enum/field.
    enum: EnumDescriptorProto.
  Returns:
    RST formatted section.
  """
  anchor = FormatAnchor(EnumCrossRefLabel(type_context.name))
  header = FormatHeader('-', 'Enum %s' % type_context.name)
  comment = type_context.LeadingCommentPathLookup()
  return anchor + header + comment + FormatEnumAsDefinitionList(
      type_context, enum)


def FormatProtoAsBlockComment(proto):
  """Format as RST a proto as a block comment.

  Useful in debugging, not usually referenced.
  """
  return '\n\nproto::\n\n' + MapLines(functools.partial(Indent, 2),
                                      str(proto)) + '\n'


def GenerateRst(proto_file):
  """Generate a RST representation from a FileDescriptor proto."""
  header = FormatHeader('=', proto_file.name)
  source_code_info = SourceCodeInfo(proto_file.source_code_info)
  # Find the earliest detached comment, attribute it to file level.
  comment = source_code_info.file_level_comment
  msgs = '\n'.join(
      FormatMessage(TypeContext(source_code_info, [4, index], msg.name), msg)
      for index, msg in enumerate(proto_file.message_type))
  enums = '\n'.join(
      FormatEnum(TypeContext(source_code_info, [5, index], enum.name), enum)
      for index, enum in enumerate(proto_file.enum_type))
  #debug_proto = FormatProtoAsBlockComment(proto_file.source_code_info)
  return header + comment + msgs + enums  #+ debug_proto


if __name__ == '__main__':
  # http://www.expobrain.net/2015/09/13/create-a-plugin-for-google-protocol-buffer/
  request = plugin_pb2.CodeGeneratorRequest()
  request.ParseFromString(sys.stdin.read())
  response = plugin_pb2.CodeGeneratorResponse()

  for proto_file in request.proto_file:
    f = response.file.add()
    f.name = proto_file.name + '.rst'
    # We don't actually generate any RST right now, we just string dump the
    # input proto file descriptor into the output file.
    f.content = GenerateRst(proto_file)

  sys.stdout.write(response.SerializeToString())
