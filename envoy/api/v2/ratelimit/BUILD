load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "ratelimit",
    srcs = ["ratelimit.proto"],
)

api_go_proto_library(
    name = "ratelimit",
    proto = ":ratelimit",
)
