load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "rls",
    srcs = ["rls.proto"],
    has_services = 1,
    deps = [
        "//envoy/api/v2:grpc_service",
    ],
)

api_go_grpc_library(
    name = "rls",
    proto = ":rls",
    deps = [
        "//envoy/api/v2:grpc_service_go_proto",
    ],
)

proto_library(
    name = "ratelimit",
    visibility = ["//envoy/api/v2:__pkg__"],
    deps = [
        ":rls",
    ],
)
