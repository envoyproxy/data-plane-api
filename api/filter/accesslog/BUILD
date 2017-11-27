load("//bazel:api_build_system.bzl", "api_proto_library")

api_proto_library(
    name = "accesslog",
    srcs = ["accesslog.proto"],
    has_services = 1,
    deps = [
        "//api:address",
        "//api:base"
    ],
)
