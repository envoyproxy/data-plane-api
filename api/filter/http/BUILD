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
    name = "router",
    srcs = ["router.proto"],
)

api_proto_library(
    name = "buffer",
    srcs = ["buffer.proto"],
)

api_proto_library(
    name = "transcoder",
    srcs = ["transcoder.proto"],
)

api_proto_library(
    name = "ip_tagging",
    srcs = ["ip_tagging.proto"],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
)
