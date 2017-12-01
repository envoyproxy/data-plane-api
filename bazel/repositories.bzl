GOOGLEAPIS_SHA = "5c6df0cd18c6a429eab739fb711c27f6e1393366" # May 14, 2017
PROMETHEUS_SHA = "6f3806018612930941127f2a7c6c453ba2c527d2" # Nov 02, 2017

PGV_GIT_SHA = "36e0c0b5946eb7347d755b9b2f55bb3fc0967846"

def api_dependencies():
    native.git_repository(
        name = "com_lyft_protoc_gen_validate",
        remote = "https://github.com/lyft/protoc-gen-validate.git",
        commit = PGV_GIT_SHA,
    )
    native.new_http_archive(
        name = "googleapis",
        strip_prefix = "googleapis-" + GOOGLEAPIS_SHA,
        url = "https://github.com/googleapis/googleapis/archive/" + GOOGLEAPIS_SHA + ".tar.gz",
        build_file_content = """
load("@com_google_protobuf//:protobuf.bzl", "cc_proto_library", "py_proto_library")

filegroup(
    name = "http_api_protos_src",
    srcs = [
        "google/api/annotations.proto",
        "google/api/http.proto",
    ],
    visibility = ["//visibility:public"],
 )

proto_library(
    name = "http_api_protos_proto",
    srcs = [":http_api_protos_src"],
    deps = ["@com_google_protobuf//:descriptor_proto"],
    visibility = ["//visibility:public"],
)

cc_proto_library(
    name = "http_api_protos",
    srcs = [
        "google/api/annotations.proto",
        "google/api/http.proto",
    ],
    default_runtime = "@com_google_protobuf//:protobuf",
    protoc = "@com_google_protobuf//:protoc",
    deps = ["@com_google_protobuf//:cc_wkt_protos"],
    visibility = ["//visibility:public"],
)

py_proto_library(
    name = "http_api_protos_py",
    srcs = [
        "google/api/annotations.proto",
        "google/api/http.proto",
    ],
    include = ".",
    default_runtime = "@com_google_protobuf//:protobuf_python",
    protoc = "@com_google_protobuf//:protoc",
    visibility = ["//visibility:public"],
    deps = ["@com_google_protobuf//:protobuf_python"],
)
        """,
    )

    native.new_http_archive(
        name = "promotheus_metrics_model",
        strip_prefix = "client_model-" + PROMETHEUS_SHA,
        url = "https://github.com/prometheus/client_model/archive/" + PROMETHEUS_SHA + ".tar.gz",
        build_file_content = """
load("@envoy_api//bazel:api_build_system.bzl", "api_proto_library")

api_proto_library(
    name = "client_model",
    srcs = [
        "metrics.proto",
    ],
)
        """,
    )
