licenses(["notice"])  # Apache 2

load("//bazel:api_build_system.bzl", "api_proto_library")
load("//bazel:envoy_build_system.bzl", "envoy_package")

envoy_package()

api_proto_library(
    name = "jwt_auth",
    srcs = ["config.proto"],
)
