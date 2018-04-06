licenses(["notice"])  # Apache 2

load("//bazel:api_build_system.bzl", "api_proto_library")

api_proto_library(
    name = "local_rbac",
    srcs = ["local_rbac.proto"],
    deps = [
        ":rbac",
    ],
)

api_proto_library(
    name = "rbac",
    srcs = ["rbac.proto"],
)
