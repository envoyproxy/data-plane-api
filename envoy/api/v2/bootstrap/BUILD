load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "bootstrap",
    srcs = ["bootstrap.proto"],
    deps = [
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2:config_source",
        "//envoy/api/v2:grpc_service",
        "//envoy/api/v2:stats",
        "//envoy/api/v2:trace",
        "//envoy/api/v2/cert",
        "//envoy/api/v2/cluster",
        "//envoy/api/v2/listener",
    ],
)

api_go_proto_library(
    name = "bootstrap",
    proto = ":bootstrap",
    deps = [
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
        "//envoy/api/v2:config_source_go_proto",
        "//envoy/api/v2:grpc_service_go_proto",
        "//envoy/api/v2:stats_go_proto",
        "//envoy/api/v2:trace_go_proto",
        "//envoy/api/v2/cert:cert_go_proto",
        "//envoy/api/v2/cluster:cluster_go_proto",
        "//envoy/api/v2/listener:listener_go_proto",
    ],
)
