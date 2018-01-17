load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "external_auth",
    srcs = [
        "external_auth.proto",
    ],
    has_services = 1,
    deps = [
        "//api:address",
    ],
)

api_proto_library(
    name = "auth",
    srcs = ["auth.proto"],
    deps = [
        "//api:sds",
    ],
)

api_go_proto_library(
    name = "auth",
    proto = ":auth",
    deps = [
        "//api:address_go_proto",
        "//api:sds_go_grpc",
        "@googleapis//:rpc_status_go_proto",
    ],
)
