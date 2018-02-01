load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "address",
    srcs = ["address.proto"],
    visibility = ["//visibility:public"],
)

api_go_proto_library(
    name = "address",
    proto = ":address",
)

api_proto_library(
    name = "base",
    srcs = ["base.proto"],
    visibility = ["//visibility:public"],
)

api_go_proto_library(
    name = "base",
    proto = ":base",
    deps = [":address_go_proto"],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    visibility = ["//visibility:public"],
    deps = [":base"],
)

api_go_proto_library(
    name = "health_check",
    proto = ":health_check",
    deps = [":base_go_proto"],
)

api_proto_library(
    name = "config_source",
    srcs = ["config_source.proto"],
    visibility = ["//visibility:public"],
    deps = [
        ":base",
        ":grpc_service",
    ],
)

api_go_proto_library(
    name = "config_source",
    proto = ":config_source",
    deps = [
        ":base_go_proto",
        ":grpc_service_go_proto",
    ],
)

api_proto_library(
    name = "grpc_service",
    srcs = ["grpc_service.proto"],
    visibility = ["//visibility:public"],
    deps = [":base"],
)

api_go_proto_library(
    name = "grpc_service",
    proto = ":grpc_service",
    deps = [":base_go_proto"],
)

api_proto_library(
    name = "protocol",
    srcs = ["protocol.proto"],
    visibility = ["//visibility:public"],
)

api_go_proto_library(
    name = "protocol",
    proto = ":protocol",
)
