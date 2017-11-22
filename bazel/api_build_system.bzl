load("@com_google_protobuf//:protobuf.bzl", "py_proto_library")

def _CcSuffix(d):
    return d + "_cc"

def _PySuffix(d):
    return d + "_py"

# TODO(htuch): has_services is currently ignored but will in future support
# gRPC stub generation.
# TOOD(htuch): Convert this to native py_proto_library once
# https://github.com/bazelbuild/bazel/issues/3935 and/or
# https://github.com/bazelbuild/bazel/issues/2626 are resolved.
def api_py_proto_library(name, srcs = [], deps = [], has_services = 0):
    py_proto_library(
        name = _PySuffix(name),
        srcs = srcs,
        default_runtime = "@com_google_protobuf//:protobuf_python",
        protoc = "@com_google_protobuf//:protoc",
        deps = [_PySuffix(d) for d in deps] + [
            "@com_lyft_protoc_gen_validate//validate:validate_py",
            "@googleapis//:http_api_protos_py",
            "@googleapis//:rpc_status_protos_py"
        ],
        visibility = ["//visibility:public"],
    )

# TODO(htuch): has_services is currently ignored but will in future support
# gRPC stub generation.
def api_proto_library(name, srcs = [], deps = [], has_services = 0, require_py = 1):
    native.proto_library(
        name = name,
        srcs = srcs,
        deps = deps + [
            "@com_google_protobuf//:any_proto",
            "@com_google_protobuf//:descriptor_proto",
            "@com_google_protobuf//:duration_proto",
            "@com_google_protobuf//:struct_proto",
            "@com_google_protobuf//:timestamp_proto",
            "@com_google_protobuf//:wrappers_proto",
            "@googleapis//:http_api_protos_lib",
            "@googleapis//:rpc_status_protos_lib",
            "@com_lyft_protoc_gen_validate//validate:validate_proto",
        ],
        visibility = ["//visibility:public"],
    )
    native.cc_proto_library(
        name = _CcSuffix(name),
        deps = [name],
        visibility = ["//visibility:public"],
    )
    if (require_py == 1):
      api_py_proto_library(name, srcs, deps, has_services)

def api_cc_test(name, srcs, proto_deps):
    native.cc_test(
        name = name,
        srcs = srcs,
        deps = [_CcSuffix(d) for d in proto_deps],
    )
