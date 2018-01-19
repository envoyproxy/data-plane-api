load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "http_connection_manager",
    srcs = ["http_connection_manager.proto"],
    deps = [
        "//envoy/api/v2:base",
        "//envoy/api/v2:config_source",
        "//envoy/api/v2:protocol",
        "//envoy/api/v2/filter/accesslog",
        "//envoy/api/v2/route",
    ],
)

api_proto_library(
    name = "mongo_proxy",
    srcs = ["mongo_proxy.proto"],
    deps = ["//envoy/api/v2/filter:fault"],
)

api_proto_library(
    name = "tcp_proxy",
    srcs = ["tcp_proxy.proto"],
    deps = [
        "//envoy/api/v2:address",
        "//envoy/api/v2/filter/accesslog",
    ],
)

api_proto_library(
    name = "redis_proxy",
    srcs = ["redis_proxy.proto"],
)

api_proto_library(
    name = "client_ssl_auth",
    srcs = ["client_ssl_auth.proto"],
    deps = ["//envoy/api/v2:address"],
)

api_proto_library(
    name = "rate_limit",
    srcs = ["rate_limit.proto"],
    deps = ["//envoy/api/v2/ratelimit"],
)

api_proto_library(
    name = "ext_authz",
    srcs = ["ext_authz.proto"],
    deps = ["//envoy/api/v2:grpc_service"],
)

proto_library(
    name = "network",
    visibility = ["//envoy:__pkg__"],
    deps = [
        ":client_ssl_auth",
        ":ext_authz",
        ":http_connection_manager",
        ":mongo_proxy",
        ":rate_limit",
        ":redis_proxy",
        ":tcp_proxy",
    ],
)
