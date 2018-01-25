load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "endpoint",
    srcs = ["endpoint.proto"],
    deps = [
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2:config_source",
        "//envoy/api/v2:health_check",
        "//envoy/api/v2:protocol",
        "//envoy/api/v2/auth:cert",
    ],
)

api_go_proto_library(
    name = "endpoint",
    proto = ":endpoint",
    deps = [
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
        "//envoy/api/v2:config_source_go_proto",
        "//envoy/api/v2:health_check_go_proto",
        "//envoy/api/v2:protocol_go_proto",
        "//envoy/api/v2/auth:cert_go_proto",
    ],
)

api_proto_library(
    name = "load_report",
    srcs = ["load_report.proto"],
    deps = [
        "//envoy/api/v2:base",
    ],
)

api_go_proto_library(
    name = "load_report",
    proto = ":load_report",
    deps = [
        "//envoy/api/v2:base_go_proto",
    ],
)
