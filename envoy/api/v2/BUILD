load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "address",
    srcs = ["address.proto"],
)

api_go_proto_library(
    name = "address",
    proto = ":address",
)

api_proto_library(
    name = "base",
    srcs = ["base.proto"],
    deps = [":address"],
)

api_go_proto_library(
    name = "base",
    proto = ":base",
    deps = [":address_go_proto"],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    deps = [":base"],
)

api_go_proto_library(
    name = "health_check",
    proto = ":health_check",
    deps = [":base_go_proto"],
)

api_proto_library(
    name = "config_source",
    srcs = ["config_source.proto"],
    deps = [
        ":base",
        ":grpc_service",
    ],
)

api_go_proto_library(
    name = "config_source",
    proto = ":config_source",
    deps = [
        ":base_go_proto",
        ":grpc_service_go_proto",
    ],
)

api_proto_library(
    name = "grpc_service",
    srcs = ["grpc_service.proto"],
    deps = [":base"],
)

api_go_proto_library(
    name = "grpc_service",
    proto = ":grpc_service",
    deps = [":base_go_proto"],
)

api_proto_library(
    name = "protocol",
    srcs = ["protocol.proto"],
)

api_go_proto_library(
    name = "protocol",
    proto = ":protocol",
)

api_proto_library(
    name = "discovery",
    srcs = ["discovery.proto"],
    deps = ["//envoy/api/v2:base"],
)

api_go_proto_library(
    name = "discovery",
    proto = ":discovery",
    deps = ["//envoy/api/v2:base_go_proto"],
)

api_proto_library(
    name = "eds",
    srcs = ["eds.proto"],
    has_services = 1,
    deps = [
        ":discovery",
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2:health_check",
        "//envoy/api/v2/endpoint",
    ],
)

api_go_grpc_library(
    name = "eds",
    proto = ":eds",
    deps = [
        ":discovery_go_proto",
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
        "//envoy/api/v2:health_check_go_proto",
        "//envoy/api/v2/endpoint:endpoint_go_proto",
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
        ":discovery_go_proto",
    ],
)

api_proto_library(
    name = "lds",
    srcs = ["lds.proto"],
    has_services = 1,
    deps = [
        ":discovery",
    ],
)

api_go_grpc_library(
    name = "lds",
    proto = ":lds",
    deps = [
        ":discovery_go_proto",
    ],
)

api_proto_library(
    name = "rds",
    srcs = ["rds.proto"],
    has_services = 1,
    deps = [
        ":discovery",
    ],
)

api_go_grpc_library(
    name = "rds",
    proto = ":rds",
    deps = [
        ":discovery_go_proto",
    ],
)

proto_library(
    name = "v2",
    visibility = ["//envoy:__pkg__"],
    deps = [
        ":cds",
        ":discovery",
        ":eds",
        ":lds",
        ":protocol",
        ":rds",
    ],
)
