import sys

from google.protobuf.compiler import plugin_pb2

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
    f.content = str(proto_file)

  sys.stdout.write(response.SerializeToString())
