load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "router",
    srcs = ["router.proto"],
    visibility = ["//docs"],
    deps = ["//envoy/config/filter/accesslog/v2:accesslog"],
)
