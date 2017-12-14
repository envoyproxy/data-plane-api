load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "auth",
    srcs = [
        "auth.proto",
        "external_auth.proto",
    ],
    deps = [
        "//api:address",
        "//api:sds",
    ],
)
