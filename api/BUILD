load("//bazel:api_build_system.bzl", "api_proto_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_grpc_library")

licenses(["notice"])  # Apache 2

# Go proto library dislikes proto libraries with no sources and only deps
proto_library(
    name = "go_protos",
    srcs = [
        "address.proto",
        "auth.proto",
        "base.proto",
        "bootstrap.proto",
        "cds.proto",
        "discovery.proto",
        "eds.proto",
        "hds.proto",
        "health_check.proto",
        "lds.proto",
        "protocol.proto",
        "rds.proto",
        "rls.proto",
        "sds.proto",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "@com_google_protobuf//:any_proto",
        "@com_google_protobuf//:descriptor_proto",
        "@com_google_protobuf//:duration_proto",
        "@com_google_protobuf//:struct_proto",
        "@com_google_protobuf//:timestamp_proto",
        "@com_google_protobuf//:wrappers_proto",
        "@googleapis//:http_api_protos_lib",
    ],
)

go_grpc_library(
    name = "go_default_library",
    importpath = "api",
    proto = ":go_protos",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_golang_protobuf//ptypes/any:go_default_library",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_github_golang_protobuf//ptypes/timestamp:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@org_golang_google_genproto//googleapis/api/annotations:go_default_library",
    ],
)

api_proto_library(
    name = "address",
    srcs = ["address.proto"],
)

api_proto_library(
    name = "auth",
    srcs = ["auth.proto"],
    deps = [":sds"],
)

api_proto_library(
    name = "base",
    srcs = ["base.proto"],
    deps = [":address"],
)

api_proto_library(
    name = "bootstrap",
    srcs = ["bootstrap.proto"],
    deps = [
        ":address",
        ":base",
        ":cds",
        ":lds",
        ":sds",
    ],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    deps = [":base"],
)

api_proto_library(
    name = "cds",
    srcs = ["cds.proto"],
    has_services = 1,
    deps = [
        ":address",
        ":base",
        ":discovery",
        ":health_check",
        ":protocol",
        ":sds",
    ],
)

api_proto_library(
    name = "discovery",
    srcs = ["discovery.proto"],
    has_services = 1,
    deps = [":base"],
)

api_proto_library(
    name = "eds",
    srcs = ["eds.proto"],
    has_services = 1,
    deps = [
        ":address",
        ":base",
        ":discovery",
        ":health_check",
    ],
)

api_proto_library(
    name = "hds",
    srcs = ["hds.proto"],
    has_services = 1,
    deps = [
        ":base",
        ":health_check",
    ],
)

api_proto_library(
    name = "lds",
    srcs = ["lds.proto"],
    has_services = 1,
    deps = [
        ":address",
        ":base",
        ":discovery",
        ":sds",
    ],
)

api_proto_library(
    name = "protocol",
    srcs = ["protocol.proto"],
)

api_proto_library(
    name = "rls",
    srcs = ["rls.proto"],
    has_services = 1,
)

api_proto_library(
    name = "rds",
    srcs = ["rds.proto"],
    has_services = 1,
    deps = [
        ":auth",
        ":base",
        ":discovery",
    ],
)

api_proto_library(
    name = "sds",
    srcs = ["sds.proto"],
    has_services = 1,
    deps = [
        ":base",
        ":discovery",
    ],
)

# TODO(htuch): Grow this to cover everything we want to generate docs for, so we can just invoke
# bazel build //api --aspects tools/protodoc/protodoc.bzl%proto_doc_aspect  --output_groups=rst
proto_library(
    name = "api",
    deps = [
        ":cds",
        ":eds",
        ":lds",
        ":rds",
    ],
)
