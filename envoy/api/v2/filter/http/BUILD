load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "router",
    srcs = ["router.proto"],
    deps = ["//envoy/api/v2/filter/accesslog"],
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
    deps = ["//envoy/api/v2:address"],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    deps = [
        "//envoy/api/v2:base",
    ],
)

api_proto_library(
    name = "fault",
    srcs = ["fault.proto"],
    deps = [
        "//envoy/api/v2/filter:fault",
        "//envoy/api/v2/route",
    ],
)

api_proto_library(
    name = "gzip",
    srcs = ["gzip.proto"],
)

api_proto_library(
    name = "squash",
    srcs = ["squash.proto"],
)

api_proto_library(
    name = "ext_authz",
    srcs = ["ext_authz.proto"],
    deps = ["//envoy/api/v2:grpc_service"],
)

proto_library(
    name = "http",
    visibility = ["//envoy/api/v2:__pkg__"],
    deps = [
        ":buffer",
        ":ext_authz",
        ":fault",
        ":health_check",
        ":lua",
        ":rate_limit",
        ":router",
        ":squash",
        ":transcoder",
    ],
)
