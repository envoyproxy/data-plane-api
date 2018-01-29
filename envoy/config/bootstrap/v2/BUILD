load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "bootstrap",
    srcs = ["bootstrap.proto"],
    deps = [
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2:cds",
        "//envoy/api/v2:config_source",
        "//envoy/api/v2:lds",
        "//envoy/api/v2/auth:cert",
        "//envoy/config/metrics/v2:metrics_service",
        "//envoy/config/metrics/v2:stats",
        "//envoy/config/ratelimit/v2:rls",
        "//envoy/config/trace/v2:trace",
    ],
)

api_go_proto_library(
    name = "bootstrap",
    proto = ":bootstrap",
    deps = [
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
        "//envoy/api/v2:cds_go_grpc",
        "//envoy/api/v2:config_source_go_proto",
        "//envoy/api/v2:lds_go_grpc",
        "//envoy/api/v2/auth:cert_go_proto",
        "//envoy/config/metrics/v2:metrics_service_go_proto",
        "//envoy/config/metrics/v2:stats_go_proto",
        "//envoy/config/ratelimit/v2:rls_go_grpc",
        "//envoy/config/trace/v2:trace_go_proto",
    ],
)
