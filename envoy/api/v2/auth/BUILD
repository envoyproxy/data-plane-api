load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library")

licenses(["notice"])  # Apache 2

package_group(
    name = "friends",
    packages = [
        "-//envoy/api/v2/core",
        "//envoy/...",
    ],
)

api_proto_library(
    name = "auth",
    srcs = ["auth.proto"],
    visibility = [":friends"],
    deps = [
        ":cert",
    ],
)

api_go_proto_library(
    name = "auth",
    proto = ":auth",
    deps = [
        ":cert_go_proto",
    ],
)

api_proto_library(
    name = "cert",
    srcs = ["cert.proto"],
    visibility = [":friends"],
    deps = [
        "//envoy/api/v2/core:base",
        "//envoy/api/v2/core:config_source",
    ],
)

api_go_proto_library(
    name = "cert",
    proto = ":cert",
    deps = [
        "//envoy/api/v2/core:base_go_proto",
        "//envoy/api/v2/core:config_source_go_proto",
    ],
)
