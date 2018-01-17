load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "route",
    srcs = ["route.proto"],
    deps = [
        "//api:base",
        "//api/auth:auth",
    ],
)

api_go_proto_library(
    name = "route",
    proto = ":route",
    deps = [
        "//api:base_go_proto",
        "//api/auth:auth_go_proto",
    ],
)
