load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "http_connection_manager",
    srcs = ["http_connection_manager.proto"],
    deps = [
        "//api:base",
        "//api:protocol",
        "//api:rds",
    ],
)

api_proto_library(
    name = "mongo_proxy",
    srcs = ["mongo_proxy.proto"],
    deps = [
    ":http_fault",
    ],
)

api_proto_library(
    name = "rate_limit",
    srcs = ["rate_limit.proto"],
)

api_proto_library(
    name = "tcp_proxy",
    srcs = ["tcp_proxy.proto"],
)

api_proto_library(
    name = "http_fault",
    srcs = ["http_fault.proto"],
    deps = [
        "//api:rds",
    ],
)

api_proto_library(
    name = "redis_proxy",
    srcs = ["redis_proxy.proto"],
    deps = [
        ":http_fault",
    ],
)
