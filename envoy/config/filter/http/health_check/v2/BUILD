load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    visibility = ["//docs"],
    deps = [
        "//envoy/api/v2/core:base",
    ],
)
