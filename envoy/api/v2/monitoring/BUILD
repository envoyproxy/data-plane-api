load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "metrics",
    srcs = ["metrics_service.proto"],
    has_services = 1,
    require_py = 0,
    deps = [
        "//envoy/api/v2:base",
        "//envoy/api/v2:grpc_service",
        "@promotheus_metrics_model//:client_model",
    ],
)

api_proto_library(
    name = "stats",
    srcs = ["stats.proto"],
    deps = [
        "//envoy/api/v2:address",
    ],
)

api_go_proto_library(
    name = "stats",
    proto = ":stats",
    deps = [
        "//envoy/api/v2:address_go_proto",
    ],
)

api_proto_library(
    name = "trace",
    srcs = ["trace.proto"],
)

api_go_proto_library(
    name = "trace",
    proto = ":trace",
)

proto_library(
    name = "monitoring",
    visibility = ["//envoy/api/v2:__pkg__"],
    deps = [
        ":metrics",
        ":stats",
        ":trace",
    ],
)
