load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "external_auth",
    srcs = [
        "external_auth.proto",
    ],
    has_services = 1,
    deps = [
        "//envoy/api/v2:address",
    ],
)

api_proto_library(
    name = "auth",
    srcs = ["auth.proto"],
    deps = [
        "//envoy/api/v2/cert",
    ],
)

api_go_proto_library(
    name = "auth",
    proto = ":auth",
    deps = [
        "//envoy/api/v2:address_go_proto",
        "//envoy/api/v2/cert:cert_go_proto",
        "@googleapis//:rpc_status_go_proto",
    ],
)
