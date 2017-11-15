load("//bazel:api_build_system.bzl", "api_proto_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_proto_library")

licenses(["notice"])  # Apache 2

# Go proto library dislikes proto libraries with no sources and only deps
proto_library(
    name = "go_protos",
    srcs = [
        "client_ssl_auth.proto",
        "mongo_proxy.proto",
        "rate_limit.proto",
        "redis_proxy.proto",
        "tcp_proxy.proto",
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
        "@com_lyft_protoc_gen_validate//validate:validate_proto",
        "@googleapis//:http_api_protos_lib",
    ],
)

go_proto_library(
    name = "go_default_library",
    importpath = "api/filter/network",
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
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
)

api_proto_library(
    name = "mongo_proxy",
    srcs = ["mongo_proxy.proto"],
    deps = ["//api/filter:fault"],
)

api_proto_library(
    name = "tcp_proxy",
    srcs = ["tcp_proxy.proto"],
    deps = [
        "//api/filter:accesslog",
        "//api:address",
    ],
)

api_proto_library(
    name = "redis_proxy",
    srcs = ["redis_proxy.proto"],
)

api_proto_library(
    name = "client_ssl_auth",
    srcs = ["client_ssl_auth.proto"],
    deps = ["//api:address"],
)

api_proto_library(
    name = "rate_limit",
    srcs = ["rate_limit.proto"],
    deps = ["//api:rls"],
)
