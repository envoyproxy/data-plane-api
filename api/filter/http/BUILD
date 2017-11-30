load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "router",
    srcs = ["router.proto"],
    deps = ["//api/filter/accesslog"],
)

api_proto_library(
    name = "lua",
    srcs = ["lua.proto"],
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
    name = "rate_limit",
    srcs = ["rate_limit.proto"],
)

api_proto_library(
    name = "ip_tagging",
    srcs = ["ip_tagging.proto"],
    deps = ["//api:address"],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
)

api_proto_library(
    name = "fault",
    srcs = ["fault.proto"],
    deps = [
        "//api:rds",
        "//api/filter:fault",
    ],
)
