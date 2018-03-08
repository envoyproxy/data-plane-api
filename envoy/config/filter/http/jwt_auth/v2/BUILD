licenses(["notice"])  # Apache 2

load("//bazel:api_build_system.bzl", "api_proto_library")

api_proto_library(
    name = "jwt_auth",
    srcs = ["config.proto"],
    deps = ["//envoy/api/v2/route:route"],
)
