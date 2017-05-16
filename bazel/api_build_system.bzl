load("@protobuf_bzl//:protobuf.bzl", "cc_proto_library")

# TODO(htuch): has_services is currently ignored but will in future support
# gRPC stub generation.
def api_proto_library(name, srcs = [], deps = [], has_services = 0):
    cc_proto_library(
        name = name,
        srcs = srcs,
        default_runtime = "@protobuf_bzl//:protobuf",
        protoc = "@protobuf_bzl//:protoc",
        deps = deps + ["@protobuf_bzl//:cc_wkt_protos"],
    )
