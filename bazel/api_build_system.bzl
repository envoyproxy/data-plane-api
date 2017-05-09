load("@protobuf_bzl//:protobuf.bzl", "cc_proto_library")

def api_proto_library(name, srcs = [], deps = []):
    cc_proto_library(
        name = name,
        srcs = srcs,
        default_runtime = "@protobuf_bzl//:protobuf",
        protoc = "@protobuf_bzl//:protoc",
        deps = deps + ["@protobuf_bzl//:cc_wkt_protos"],
    )
