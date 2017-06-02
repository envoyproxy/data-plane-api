load("@protobuf_bzl//:protobuf.bzl", "cc_proto_library", "py_proto_library")

# TODO(htuch): has_services is currently ignored but will in future support
# gRPC stub generation.
def api_cc_proto_library(name, srcs = [], deps = [], has_services = 0):
    cc_proto_library(
        name = name,
        srcs = srcs,
        default_runtime = "//external:protobuf",
        protoc = "//external:protoc",
        deps = deps + [
            "@googleapis//:http_api_protos",
            "@protobuf_bzl//:cc_wkt_protos",
        ],
        visibility = ["//visibility:public"],
    )

# TODO(htuch): has_services is currently ignored but will in future support
# gRPC stub generation.
def api_py_proto_library(name, srcs = [], deps = [], has_services = 0):
    py_proto_library(
        name = name,
        srcs = srcs,
        default_runtime = "//external:protobuf_python",
        protoc = "//external:protoc",
        deps = [d + "_py" for d in deps] + ["@googleapis//:http_api_protos_py"],
        visibility = ["//visibility:public"],
    )

def api_proto_library(name, srcs = [], deps = [], has_services = 0):
  api_cc_proto_library(name, srcs, deps, has_services)
  api_py_proto_library(name + "_py", srcs, deps, has_services)
