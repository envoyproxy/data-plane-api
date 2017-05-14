load("@protobuf//:protobuf.bzl", "cc_proto_library")

def api_proto_library(name, srcs = [], deps = []):
    cc_proto_library(
        name = name,
        srcs = srcs,
        default_runtime = "@protobuf//:protobuf",
        protoc = "@protobuf//:protoc",
        deps = deps + ["@protobuf//:cc_wkt_protos"] +
               ["@googleapis//:http_api_protos"],
    )
