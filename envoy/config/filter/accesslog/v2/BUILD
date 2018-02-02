load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "accesslog",
    srcs = ["accesslog.proto"],
    visibility = [
        "//envoy/config/filter/http/router/v2:__pkg__",
        "//envoy/config/filter/network/http_connection_manager/v2:__pkg__",
        "//envoy/config/filter/network/tcp_proxy/v2:__pkg__",
        "//envoy/service/accesslog/v2:__pkg__",
    ],
    deps = [
        "//envoy/api/v2/core:address",
        "//envoy/api/v2/core:base",
        "//envoy/api/v2/core:grpc_service",
    ],
)
