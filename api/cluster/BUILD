load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "cluster",
    srcs = ["cluster.proto"],
    has_services = 1,
    deps = [
        "//api:address",
        "//api:base",
        "//api:config_source",
        "//api:health_check",
        "//api:protocol",
        "//api:sds",
    ],
)

api_go_proto_library(
    name = "cluster",
    proto = ":cluster",
    deps = [
        "//api:address_go_proto",
        "//api:base_go_proto",
        "//api:config_source_go_proto",
        "//api:health_check_go_proto",
        "//api:protocol_go_proto",
        "//api:sds_go_grpc",
    ],
)
