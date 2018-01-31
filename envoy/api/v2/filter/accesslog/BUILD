load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "accesslog",
    srcs = ["accesslog.proto"],
    deps = [
        "//envoy/api/v2/core:address",
        "//envoy/api/v2/core:base",
        "//envoy/api/v2/core:grpc_service",
    ],
)
