load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "mongo_proxy",
    srcs = ["mongo_proxy.proto"],
    visibility = ["//docs"],
    deps = ["//envoy/config/filter/fault/v2:fault"],
)
