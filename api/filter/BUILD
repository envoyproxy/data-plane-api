load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "rate_limit",
    srcs = ["rate_limit.proto"],
)

api_proto_library(
    name = "fault",
    srcs = ["fault.proto"],
    deps = [
        "//api:rds",
    ],
)
