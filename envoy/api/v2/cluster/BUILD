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
