load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "tcp_proxy",
    srcs = ["tcp_proxy.proto"],
    visibility = ["//docs"],
    deps = [
        "//envoy/api/v2/core:address",
        "//envoy/config/filter/accesslog/v2:accesslog",
    ],
)
