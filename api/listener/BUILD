load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "listener",
    srcs = ["listener.proto"],
    deps = [
        "//api:address",
        "//api:base",
        "//api/cert:cert",
    ],
)

api_go_proto_library(
    name = "listener",
    proto = ":listener",
    deps = [
        "//api:address_go_proto",
        "//api:base_go_proto",
        "//api/cert:cert_go_proto",
    ],
)
