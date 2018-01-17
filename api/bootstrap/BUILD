load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "bootstrap",
    srcs = ["bootstrap.proto"],
    deps = [
        "//api:address",
        "//api:base",
        "//api:config_source",
        "//api:grpc_service",
        "//api:stats",
        "//api:trace",
        "//api/cluster:cluster",
        "//api/listener:listener",
        "//api/cert:cert",
    ],
)

api_go_proto_library(
    name = "bootstrap",
    proto = ":bootstrap",
    deps = [
        "//api:address_go_proto",
        "//api:base_go_proto",
        "//api:config_source_go_proto",
        "//api:grpc_service_go_proto",
        "//api:stats_go_proto",
        "//api:trace_go_proto",
        "//api/cluster:cluster_go_proto",
        "//api/listener:listener_go_proto",
        "//api/cert:cert_go_proto",
    ],
)


