load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "router",
    srcs = ["router.proto"],
    visibility = ["//envoy:friends"],
    deps = ["//envoy/api/v2/filter/accesslog"],
)

api_proto_library(
    name = "lua",
    srcs = ["lua.proto"],
    visibility = ["//envoy:friends"],
)

api_proto_library(
    name = "buffer",
    srcs = ["buffer.proto"],
    visibility = ["//envoy:friends"],
)

api_proto_library(
    name = "transcoder",
    srcs = ["transcoder.proto"],
    visibility = ["//envoy:friends"],
)

api_proto_library(
    name = "rate_limit",
    srcs = ["rate_limit.proto"],
    visibility = ["//envoy:friends"],
)

api_proto_library(
    name = "ip_tagging",
    srcs = ["ip_tagging.proto"],
    visibility = ["//envoy:friends"],
    deps = ["//envoy/api/v2/core:address"],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    visibility = ["//envoy:friends"],
    deps = [
        "//envoy/api/v2/core:base",
    ],
)

api_proto_library(
    name = "fault",
    srcs = ["fault.proto"],
    visibility = ["//envoy:friends"],
    deps = [
        "//envoy/api/v2/filter:fault",
        "//envoy/api/v2/route",
    ],
)

api_proto_library(
    name = "gzip",
    srcs = ["gzip.proto"],
    visibility = ["//envoy:friends"],
)

api_proto_library(
    name = "squash",
    srcs = ["squash.proto"],
    visibility = ["//envoy:friends"],
)

api_proto_library(
    name = "ext_authz",
    srcs = ["ext_authz.proto"],
    visibility = ["//envoy:friends"],
    deps = ["//envoy/api/v2/core:grpc_service"],
)

proto_library(
    name = "http",
    visibility = ["//envoy:__pkg__"],
    deps = [
        ":buffer",
        ":ext_authz",
        ":fault",
        ":gzip",
        ":health_check",
        ":lua",
        ":rate_limit",
        ":router",
        ":squash",
        ":transcoder",
    ],
)
