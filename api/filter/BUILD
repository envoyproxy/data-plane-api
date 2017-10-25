load("//bazel:api_build_system.bzl", "api_proto_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_proto_library")

licenses(["notice"])  # Apache 2

# Go proto library dislikes proto libraries with no sources and only deps
proto_library(
    name = "go_protos",
    srcs = [
        "fault.proto",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "@com_google_protobuf//:duration_proto",
    ],
)

go_proto_library(
    name = "go_default_library",
    importpath = "api/filter",
    proto = ":go_protos",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
    ],
)

api_proto_library(
    name = "fault",
    srcs = ["fault.proto"],
)
