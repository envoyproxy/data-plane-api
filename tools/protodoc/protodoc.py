# protoc plugin to map from FileDescriptorProtos to Envoy doc style RST.
# See https://github.com/google/protobuf/blob/master/src/google/protobuf/descriptor.proto
# for the underlying protos mentioned in this file.

import functools
import sys

from google.protobuf.compiler import plugin_pb2

# Namespace prefix for Envoy APIs.
ENVOY_API_NAMESPACE_PREFIX = '.envoy.api.v2.'


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


def FormatHeader(style, text):
  """Format RST header.

  Args:
    style: underline style, e.g. '=', '-'.
    text: header text
  Returns:
    RST formatted header.
  """
  return '%s\n%s\n\n' % (text, style * len(text))


def FormatFieldTypeAsJson(field):
  """Format FieldDescriptorProto.Type as a pseudo-JSON string.

  Args:
    field: FieldDescriptor proto.
  Return:
    RST formatted pseudo-JSON string representation of field type.
  """
  if field.label == field.LABEL_REPEATED:
    return '[]'
  if field.type == field.TYPE_MESSAGE:
    return '"{...}"'
  return '"..."'


def FormatMessageAsJson(msg):
  """Format a message definition DescriptorProto as a pseudo-JSON block.

  Args:
    msg: message definition DescriptorProto.
  Return:
    RST formatted pseudo-JSON string representation of message definition.
  """
  lines = ['"%s": %s' % (f.name, FormatFieldTypeAsJson(f)) for f in msg.field]
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

  def Wrapped(s):
    return '{%s}' % s

  remap_fqn = {
      '.google.protobuf.UInt32Value': Wrapped('uint32'),
      '.google.protobuf.UInt64Value': Wrapped('uint64'),
      '.google.protobuf.BoolValue': Wrapped('bool'),
  }
  if fqn in remap_fqn:
    return remap_fqn[fqn]

  return fqn


def FormatEmph(s):
  """RST format a string for emphasis."""
  return '*%s*' % s


def FormatFieldType(field):
  """Format a FieldDescriptorProto type description.

  Adds cross-refs for message types.
  TODO(htuch): Add cross-refs for enums as well.

  Args:
    field: FieldDescriptor proto.
  Return:
    RST formatted field type.
  """
  if field.type == field.TYPE_MESSAGE and field.type_name.startswith(
      ENVOY_API_NAMESPACE_PREFIX):
    type_name = NormalizeFQN(field.type_name)
    return ':ref:`%s <%s>`' % (type_name, MessageCrossRefLabel(type_name))
  # TODO(htuch): Replace with enum handling.
  if field.type_name:
    return FormatEmph(NormalizeFQN(field.type_name))
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
    return FormatEmph(pretty_type_names[field.type])
  raise ProtodocError('Unknown field type ' + str(field.type))


def StripLeadingSpace(s):
  """Remove leading space in flat comment strings."""
  return MapLines(lambda s: s[1:], s)


def MessageCrossRefLabel(msg_name):
  """Message cross reference label."""
  return 'envoy_api_%s' % msg_name


def FieldCrossRefLabel(msg_name, field_name):
  """Field cross reference label."""
  return 'envoy_api_%s_%s' % (msg_name, field_name)


def FormatAnchor(label):
  """Format a label as an Envoy API RST anchor."""
  return '.. _%s:\n\n' % label


def FormatFieldAsDefinitionListItem(source_code_info, msg, path, field):
  """Format a FieldDescriptorProto as RST definition list item.

  Args:
    source_code_info: SourceCodeInfo object.
    msg: MessageDescriptorProto.
    path: a list of path indexes as per
      https://github.com/google/protobuf/blob/a08b03d4c00a5793b88b494f672513f6ad46a681/src/google/protobuf/descriptor.proto#L717.
    field: FieldDescriptorProto.
  Returns:
    RST formatted definition list item.
  """
  anchor = FormatAnchor(FieldCrossRefLabel(msg.name, field.name))
  comment = '(%s) ' % FormatFieldType(
      field) + source_code_info.LeadingCommentPathLookup(path)
  return anchor + field.name + '\n' + MapLines(
      functools.partial(Indent, 2), comment)


def FormatMessageAsDefinitionList(source_code_info, path, msg):
  """Format a MessageDescriptorProto as RST definition list.

  Args:
    source_code_info: SourceCodeInfo object.
    path: a list of path indexes as per
      https://github.com/google/protobuf/blob/a08b03d4c00a5793b88b494f672513f6ad46a681/src/google/protobuf/descriptor.proto#L717.
    msg: MessageDescriptorProto.
  Returns:
    RST formatted definition list item.
  """
  return '\n\n'.join(
      FormatFieldAsDefinitionListItem(source_code_info, msg, path + [2, index],
                                      field)
      for index, field in enumerate(msg.field)) + '\n'


def FormatMessage(source_code_info, path, msg):
  """Format a MessageDescriptorProto as RST section.

  Args:
    source_code_info: SourceCodeInfo object.
    path: a list of path indexes as per
      https://github.com/google/protobuf/blob/a08b03d4c00a5793b88b494f672513f6ad46a681/src/google/protobuf/descriptor.proto#L717.
    msg: MessageDescriptorProto.
  Returns:
    RST formatted section.
  """
  anchor = FormatAnchor(MessageCrossRefLabel(msg.name))
  header = FormatHeader('-', msg.name)
  comment = source_code_info.LeadingCommentPathLookup(path)
  return anchor + header + comment + FormatMessageAsJson(
      msg) + FormatMessageAsDefinitionList(source_code_info, path, msg)


def FormatProtoAsBlockComment(proto):
  """Format as RST a proto as a block comment.

  Useful in debugging, not usually referenced.
  """
  return '\n\nproto::\n\n' + MapLines(functools.partial(Indent, 2),
                                      str(proto)) + '\n'


def GenerateRst(proto_file):
  """Generate a RST representation from a FileDescriptor proto.

  """
  header = FormatHeader('=', proto_file.name)
  source_code_info = SourceCodeInfo(proto_file.source_code_info)
  # Find the earliest detached comment, attribute it to file level.
  comment = source_code_info.file_level_comment
  msgs = '\n'.join(
      FormatMessage(source_code_info, [4, index], msg)
      for index, msg in enumerate(proto_file.message_type))
  #debug_proto = FormatProtoAsBlockComment(proto_file.source_code_info)
  return header + comment + msgs  #+ debug_proto


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
