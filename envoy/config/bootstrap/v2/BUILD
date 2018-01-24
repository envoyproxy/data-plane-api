load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "bootstrap",
    srcs = ["bootstrap.proto"],
    deps = [
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2:config_source",
        "//envoy/api/v2/auth:cert",
        "//envoy/api/v2/cluster",
        "//envoy/api/v2/listener",
        "//envoy/config/metrics/v2:stats",
        "//envoy/config/metrics/v2:metrics_service",
        "//envoy/api/v2/monitoring:trace",
        "//envoy/config/ratelimit/v2:rls",
    ],
)

api_go_proto_library(
    name = "bootstrap",
    proto = ":bootstrap",
    deps = [
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
        "//envoy/api/v2:config_source_go_proto",
        "//envoy/api/v2/auth:cert_go_proto",
        "//envoy/api/v2/cluster:cluster_go_proto",
        "//envoy/api/v2/listener:listener_go_proto",
        "//envoy/config/metrics/v2:stats_go_proto",
        "//envoy/config/metrics/v2:metrics_service_go_proto",
        "//envoy/api/v2/monitoring:trace_go_proto",
        "//envoy/config/ratelimit/v2:rls_go_grpc",
    ],
)
