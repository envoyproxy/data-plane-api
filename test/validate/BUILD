load("//bazel:api_build_system.bzl", "api_cc_test", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "test",
    srcs = ["test.proto"],
)

api_cc_test(
    name = "pgv_test",
    srcs = ["pgv_test.cc"],
    proto_deps = [":test"],
)
