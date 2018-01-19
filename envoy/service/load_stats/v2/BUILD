load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "lrs",
    srcs = ["lrs.proto"],
    has_services = 1,
    deps = [
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
    ],
)

api_go_grpc_library(
    name = "lrs",
    proto = ":lrs",
    deps = [
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
    ],
)
