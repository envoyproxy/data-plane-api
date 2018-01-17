load("//bazel:api_build_system.bzl", "api_proto_library")

api_proto_library(
    name = "accesslog",
    srcs = ["accesslog.proto"],
    has_services = 1,
    deps = [
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2:grpc_service",
    ],
)
