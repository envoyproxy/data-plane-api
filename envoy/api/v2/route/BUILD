load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "route",
    srcs = ["route.proto"],
    deps = [
        "//envoy/api/v2/core:base",
        "//envoy/api/v2/auth",
    ],
)

api_go_proto_library(
    name = "route",
    proto = ":route",
    deps = [
        "//envoy/api/v2/core:base_go_proto",
        "//envoy/api/v2/auth:auth_go_proto",
    ],
)
