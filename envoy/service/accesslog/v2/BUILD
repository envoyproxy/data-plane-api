load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "als",
    srcs = ["als.proto"],
    has_services = 1,
    deps = [
        "//envoy/api/v2:base",
        "//envoy/api/v2:grpc_service",
        "//envoy/api/v2/filter/accesslog",
    ],
)
