load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "discovery",
    srcs = ["discovery.proto"],
    has_services = 1,
    deps = ["//api:base"],
)

api_go_grpc_library(
    name = "discovery",
    proto = ":discovery",
    deps = ["//api:base_go_proto"],
)

api_proto_library(
    name = "eds",
    srcs = ["eds.proto"],
    has_services = 1,
    deps = [
        ":discovery",
        "//api:address",
        "//api:base",
        "//api:health_check",
    ],
)

api_go_grpc_library(
    name = "eds",
    proto = ":eds",
    deps = [
        ":discovery_go_grpc",
        "//api:address_go_proto",
        "//api:base_go_proto",
        "//api:health_check_go_proto",
    ],
)


api_proto_library(
    name = "cds",
    srcs = ["cds.proto"],
    has_services = 1,
    deps = [
        ":discovery",
    ],
)

api_go_grpc_library(
    name = "cds",
    proto = ":cds",
    deps = [
        ":discovery_go_grpc",
    ],
)

api_proto_library(
    name = "sds",
    srcs = ["sds.proto"],
    has_services = 1,
    deps = [
        ":discovery",
    ],
)

api_go_grpc_library(
    name = "sds",
    proto = ":sds",
    deps = [
        ":discovery_go_grpc",
    ],
)

