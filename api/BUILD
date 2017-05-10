load("//bazel:api_build_system.bzl", "api_proto_library")

api_proto_library(
    name = "address",
    srcs = ["address.proto"],
)

api_proto_library(
    name = "base",
    srcs = ["base.proto"],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    deps = [
        ":address",
        ":base",
    ],
)

api_proto_library(
    name = "tls_context",
    srcs = ["tls_context.proto"],
)

api_proto_library(
    name = "cds",
    srcs = ["cds.proto"],
    deps = [
        ":address",
        ":base",
        ":health_check",
        ":tls_context",
    ],
)

api_proto_library(
    name = "eds",
    srcs = ["eds.proto"],
    deps = [
        ":base",
        ":health_check",
    ],
)

api_proto_library(
    name = "lds",
    srcs = ["lds.proto"],
    deps = [
        ":address",
        ":base",
        ":tls_context",
    ],
)

api_proto_library(
    name = "rds",
    srcs = ["rds.proto"],
    deps = [":base"],
)
