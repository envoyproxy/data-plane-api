load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "listener",
    srcs = ["listener.proto"],
    deps = [
        "//envoy/api/v2:address",
        "//envoy/api/v2:base",
        "//envoy/api/v2/cert",
    ],
)

api_go_proto_library(
    name = "listener",
    proto = ":listener",
    deps = [
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2:base_go_proto",
        "//envoy/api/v2/cert:cert_go_proto",
    ],
)
