load("//bazel:api_build_system.bzl", "api_cc_test")

licenses(["notice"])  # Apache 2

api_cc_test(
    name = "build_test",
    srcs = ["build_test.cc"],
    proto_deps = [
        "//api:ads",
        "//api:cds",
        "//api:eds",
        "//api:hds",
        "//api:lds",
        "//api:rds",
        "//api:rlds",
    ],
)
