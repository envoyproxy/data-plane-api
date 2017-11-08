GOOGLEAPIS_SHA = "5c6df0cd18c6a429eab739fb711c27f6e1393366" # May 14, 2017
PROMETHEUS_SHA = "6f3806018612930941127f2a7c6c453ba2c527d2" # Nov 02, 2017

PGV_GIT_SHA = "f3332cbd75bb28f711377dfb84761ef0d52eca0f"
PGV_TAR_SHA = "039ffa842eb62495b6aca305a4eb3d6dc3ac1dd056e228fba5e720161ddfb9c1"

def api_dependencies():
    native.http_archive(
        name = "com_lyft_protoc_gen_validate",
        strip_prefix = "protoc-gen-validate-" + PGV_GIT_SHA,
        sha256 = PGV_TAR_SHA,
        url = "https://github.com/lyft/protoc-gen-validate/archive/" + PGV_GIT_SHA + ".tar.gz",
    )
    native.new_http_archive(
        name = "googleapis",
        strip_prefix = "googleapis-" + GOOGLEAPIS_SHA,
        url = "https://github.com/googleapis/googleapis/archive/" + GOOGLEAPIS_SHA + ".tar.gz",
        build_file_content = """
load("@com_google_protobuf//:protobuf.bzl", "py_proto_library")

filegroup(
    name = "http_api_protos_src",
    srcs = [
        "google/api/annotations.proto",
        "google/api/http.proto",
    ],
    visibility = ["//visibility:public"],
 )

proto_library(
    name = "http_api_protos_lib",
    srcs = [":http_api_protos_src"],
    deps = ["@com_google_protobuf//:descriptor_proto"],
    visibility = ["//visibility:public"],
)

cc_proto_library(
    name = "http_api_protos",
    deps = [":http_api_protos_lib"],
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

filegroup(
    name = "rpc_status_protos_src",
    srcs = [
        "google/rpc/status.proto",
    ],
    visibility = ["//visibility:public"],
 )

proto_library(
    name = "rpc_status_protos_lib",
    srcs = [":rpc_status_protos_src"],
    deps = ["@com_google_protobuf//:any_proto"],
    visibility = ["//visibility:public"],
)

cc_proto_library(
    name = "rpc_status_protos",
    deps = [":rpc_status_protos_lib"],
    visibility = ["//visibility:public"],
)

py_proto_library(
    name = "rpc_status_protos_py",
    srcs = [
        "google/rpc/status.proto",
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

filegroup(
    name = "client_model_protos_src",
    srcs = [
        "metrics.proto",
    ],
    visibility = ["//visibility:public"],
 )

proto_library(
    name = "client_model_protos_lib",
    srcs = [":client_model_protos_src"],
    visibility = ["//visibility:public"],
)

cc_proto_library(
    name = "client_model_protos",
    deps = [":client_model_protos_lib"],
    visibility = ["//visibility:public"],
)
        """,
    )