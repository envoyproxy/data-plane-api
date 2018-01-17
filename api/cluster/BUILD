load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "circuit_breaker",
    srcs = ["circuit_breaker.proto"],
    deps = [
        "//api:base",
    ],
)

api_go_proto_library(
    name = "circuit_breaker",
    proto = ":circuit_breaker",
    deps = [
        "//api:base_go_proto",
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
    name = "cluster_def",
    srcs = ["cluster.proto"],
    deps = [
        ":circuit_breaker",
        ":outlier_detection",
        "//api:address",
        "//api:base",
        "//api:config_source",
        "//api:health_check",
        "//api:protocol",
        "//api/cert:cert",
    ],
)

api_go_proto_library(
    name = "cluster_def",
    proto = ":cluster_def",
    deps = [
        ":circuit_breaker_go_proto",
        ":outlier_detection_go_proto",
        "//api:address_go_proto",
        "//api:base_go_proto",
        "//api:config_source_go_proto",
        "//api:health_check_go_proto",
        "//api:protocol_go_proto",
        "//api/cert:cert_go_proto",
    ],
)

proto_library(
    name = "cluster",
    deps = [
        ":circuit_breaker",
        ":cluster_def",
        ":outlier_detection",
    ],
    visibility = ["//api:__pkg__"],
)
