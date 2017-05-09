load("//bazel:api_build_system.bzl", "api_proto_library")

api_proto_library(
    name = "node",
    srcs = ["node.proto"],
)

api_proto_library(
    name = "lds",
    srcs = ["lds.proto"],
    deps = [":node"],
)

api_proto_library(
    name = "rds",
    srcs = ["rds.proto"],
    deps = [":node"],
)
