load("//bazel:api_build_system.bzl", "api_proto_library")

api_proto_library(
    name = "address",
    srcs = ["address.proto"],
)

api_proto_library(
    name = "node",
    srcs = ["node.proto"],
)

api_proto_library(
    name = "ssl_context",
    srcs = ["ssl_context.proto"],
)

api_proto_library(
    name = "cds",
    srcs = ["cds.proto"],
    deps = [
        ":address",
        ":node",
        ":ssl_context",
    ],
)

api_proto_library(
    name = "lds",
    srcs = ["lds.proto"],
    deps = [
        ":address",
        ":node",
        ":ssl_context",
    ],
)

api_proto_library(
    name = "rds",
    srcs = ["rds.proto"],
    deps = [":node"],
)
