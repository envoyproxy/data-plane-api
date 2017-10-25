load("//bazel:api_build_system.bzl", "api_proto_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_proto_library")

licenses(["notice"])  # Apache 2

# Go proto library dislikes proto libraries with no sources and only deps
proto_library(
    name = "go_protos",
    srcs = [
        "accesslog.proto",
        "buffer.proto",
        "fault.proto",
        "health_check.proto",
        "http_connection_manager.proto",
        "ip_tagging.proto",
        "rate_limit.proto",
        "router.proto",
        "transcoder.proto",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//api:go_protos",
        "//api/filter:go_protos",
        "@com_google_protobuf//:any_proto",
        "@com_google_protobuf//:descriptor_proto",
        "@com_google_protobuf//:duration_proto",
        "@com_google_protobuf//:struct_proto",
        "@com_google_protobuf//:timestamp_proto",
        "@com_google_protobuf//:wrappers_proto",
        "@googleapis//:http_api_protos_lib",
    ],
)

go_proto_library(
    name = "go_default_library",
    importpath = "api/filter/http",
    proto = ":go_protos",
    visibility = ["//visibility:public"],
    deps = [
        "//api:go_default_library",
        "//api/filter:go_default_library",
        "@com_github_golang_protobuf//ptypes/any:go_default_library",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_github_golang_protobuf//ptypes/timestamp:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@org_golang_google_genproto//googleapis/api/annotations:go_default_library",
    ],
)

api_proto_library(
    name = "http_connection_manager",
    srcs = ["http_connection_manager.proto"],
    deps = [
        ":accesslog",
        "//api:base",
        "//api:protocol",
        "//api:rds",
    ],
)

api_proto_library(
    name = "accesslog",
    srcs = ["accesslog.proto"],
    deps = ["//api:base"],
)

api_proto_library(
    name = "router",
    srcs = ["router.proto"],
)

api_proto_library(
    name = "buffer",
    srcs = ["buffer.proto"],
)

api_proto_library(
    name = "transcoder",
    srcs = ["transcoder.proto"],
)

api_proto_library(
    name = "rate_limit",
    srcs = ["rate_limit.proto"],
)

api_proto_library(
    name = "ip_tagging",
    srcs = ["ip_tagging.proto"],
    deps = ["//api:address"],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
)

api_proto_library(
    name = "fault",
    srcs = ["fault.proto"],
    deps = [
        "//api:rds",
        "//api/filter:fault",
    ],
)
