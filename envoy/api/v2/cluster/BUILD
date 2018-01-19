load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "circuit_breaker",
    srcs = ["circuit_breaker.proto"],
    deps = [
        "//envoy/api/v2:base",
    ],
)

api_go_proto_library(
    name = "circuit_breaker",
    proto = ":circuit_breaker",
    deps = [
        "//envoy/api/v2:base_go_proto",
    ],
)

api_proto_library(
    name = "outlier_detection",
    srcs = ["outlier_detection.proto"],
)

api_go_proto_library(
    name = "outlier_detection",
    proto = ":outlier_detection",
)

api_proto_library(
    name = "cluster",
    srcs = ["cluster.proto"],
    deps = [
        ":circuit_breaker",
        ":outlier_detection",
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2:config_source",
        "//envoy/api/v2:health_check",
        "//envoy/api/v2:protocol",
        "//envoy/api/v2/auth:cert",
    ],
)

api_go_proto_library(
    name = "cluster",
    proto = ":cluster",
    deps = [
        ":circuit_breaker_go_proto",
        ":outlier_detection_go_proto",
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
        "//envoy/api/v2:config_source_go_proto",
        "//envoy/api/v2:health_check_go_proto",
        "//envoy/api/v2:protocol_go_proto",
        "//envoy/api/v2/auth:cert_go_proto",
    ],
)
