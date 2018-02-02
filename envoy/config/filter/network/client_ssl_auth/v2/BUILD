load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "client_ssl_auth",
    srcs = ["client_ssl_auth.proto"],
    visibility = ["//docs"],
    deps = ["//envoy/api/v2/core:address"],
)
