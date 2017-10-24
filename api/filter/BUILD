load("//bazel:api_build_system.bzl", "api_proto_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_grpc_library")

licenses(["notice"])  # Apache 2

# Go proto library dislikes proto libraries with no sources and only deps
proto_library(
    name = "go_protos",
    srcs = [
        "http_connection_manager.proto",
        "mongo_proxy.proto",
        "rate_limit.proto",
        "tcp_proxy.proto",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//api:go_protos",
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
    importpath = "api/filter",
    proto = ":go_protos",
    visibility = ["//visibility:public"],
    deps = [
        "//api:go_default_library",
        "@com_github_golang_protobuf//ptypes/any:go_default_library",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_github_golang_protobuf//ptypes/timestamp:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@org_golang_google_genproto//googleapis/api/annotations:go_default_library",
    ],
)

api_proto_library(
    name = "fault",
    srcs = ["fault.proto"],
)
