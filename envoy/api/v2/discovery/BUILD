load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "common",
    srcs = ["common.proto"],
    deps = ["//envoy/api/v2:base"],
)

api_go_proto_library(
    name = "common",
    proto = ":common",
    deps = ["//envoy/api/v2:base_go_proto"],
)

api_proto_library(
    name = "ads",
    srcs = ["ads.proto"],
    has_services = 1,
    deps = [
        ":common",
    ],
)

api_go_grpc_library(
    name = "ads",
    proto = ":ads",
    deps = [
        ":common_go_proto",
    ],
)

api_proto_library(
    name = "eds",
    srcs = ["eds.proto"],
    has_services = 1,
    deps = [
        ":common",
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2:health_check",
    ],
)

api_go_grpc_library(
    name = "eds",
    proto = ":eds",
    deps = [
        ":common_go_proto",
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
        "//envoy/api/v2:health_check_go_proto",
    ],
)

api_proto_library(
    name = "cds",
    srcs = ["cds.proto"],
    has_services = 1,
    deps = [
        ":common",
    ],
)

api_go_grpc_library(
    name = "cds",
    proto = ":cds",
    deps = [
        ":common_go_proto",
    ],
)

api_proto_library(
    name = "lds",
    srcs = ["lds.proto"],
    has_services = 1,
    deps = [
        ":common",
    ],
)

api_go_grpc_library(
    name = "lds",
    proto = ":lds",
    deps = [
        ":common_go_proto",
    ],
)

api_proto_library(
    name = "rds",
    srcs = ["rds.proto"],
    has_services = 1,
    deps = [
        ":common",
    ],
)

api_go_grpc_library(
    name = "rds",
    proto = ":rds",
    deps = [
        ":common_go_proto",
    ],
)

api_proto_library(
    name = "sds",
    srcs = ["sds.proto"],
    has_services = 1,
    deps = [
        ":common",
    ],
)

api_go_grpc_library(
    name = "sds",
    proto = ":sds",
    deps = [
        ":common_go_proto",
    ],
)

proto_library(
    name = "discovery",
    visibility = ["//envoy/api/v2:__pkg__"],
    deps = [
        ":ads",
        ":cds",
        ":common",
        ":eds",
        ":lds",
        ":rds",
    ],
)
