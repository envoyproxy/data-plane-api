load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "cert",
    srcs = ["cert.proto"],
    deps = [
        "//api:base",
        "//api:config_source",
    ],
)

api_go_proto_library(
    name = "cert",
    proto = ":cert",
    deps = [
        "//api:base_go_proto",
        "//api:config_source_go_proto",
    ],
)
