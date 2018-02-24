load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "http_connection_manager",
    srcs = ["http_connection_manager.proto"],
    deps = [
        "//envoy/api/v2:rds",
        "//envoy/api/v2/core:base",
        "//envoy/api/v2/core:config_source",
        "//envoy/api/v2/core:protocol",
        "//envoy/config/filter/accesslog/v2:accesslog",
        "//envoy/type:percent",
    ],
)
