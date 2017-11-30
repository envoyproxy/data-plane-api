load("@com_google_protobuf//:protobuf.bzl", "py_proto_library")
load("@com_lyft_protoc_gen_validate//bazel:pgv_proto_library.bzl", "pgv_cc_proto_library")

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
        ],
        visibility = ["//visibility:public"],
    )

# TODO(htuch): has_services is currently ignored but will in future support
# gRPC stub generation.
def api_proto_library(name, srcs = [], deps = [], has_services = 0, require_py = 1):
    # This is now vestigial, since there are no direct consumers in
    # data-plane-api. However, we want to maintain native proto_library support
    # in the proto graph to (1) support future C++ use of native rules with
    # cc_proto_library (or some Bazel aspect that works on proto_library) when
    # it can play well with the PGV plugin and (2) other language support that
    # can make use of native proto_library.
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
            "@googleapis//:http_api_protos_proto",
            "@com_lyft_protoc_gen_validate//validate:validate_proto",
        ],
        visibility = ["//visibility:public"],
    )
    # Under the hood, this is just an extension of the Protobuf library's
    # bespoke cc_proto_library. It doesn't consume proto_library as a proto
    # provider. Hopefully one day we can move to a model where this target and
    # the proto_library above are aligned.
    pgv_cc_proto_library(
        name = _CcSuffix(name),
        srcs = srcs,
        deps = [_CcSuffix(d) for d in deps],
        external_deps = [
            "@com_google_protobuf//:cc_wkt_protos",
            "@googleapis//:http_api_protos",
        ],
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
