load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "trace",
    srcs = ["trace.proto"],
    deps = [
        "//envoy/api/v2:grpc_service",
    ],
)

api_go_proto_library(
    name = "trace",
    proto = ":trace",
    deps = [
        "//envoy/api/v2:grpc_service_go_proto",
    ],
)
