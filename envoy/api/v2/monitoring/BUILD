load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

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
