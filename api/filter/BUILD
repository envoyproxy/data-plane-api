load("//bazel:api_build_system.bzl", "api_proto_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_proto_library")

licenses(["notice"])  # Apache 2

# Go proto library dislikes proto libraries with no sources and only deps
proto_library(
    name = "go_protos",
    srcs = [
        "accesslog.proto",
        "fault.proto",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//api:go_protos",
        "@com_google_protobuf//:duration_proto",
        "@com_google_protobuf//:struct_proto",
    ],
)

go_proto_library(
    name = "go_default_library",
    importpath = "api/filter",
    proto = ":go_protos",
    visibility = ["//visibility:public"],
    deps = [
        "//api:go_default_library",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
    ],
)

api_proto_library(
    name = "fault",
    srcs = ["fault.proto"],
)

api_proto_library(
    name = "accesslog",
    srcs = ["accesslog.proto"],
    has_services = 1,
    deps = [
      "//api:accesslog",
      "//api:base",
    ],
)
