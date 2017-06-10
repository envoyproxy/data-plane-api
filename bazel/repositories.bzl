def api_dependencies():
    native.new_git_repository(
        name = "googleapis",
        # Head of master at 5/14.
        commit = "5c6df0cd18c6a429eab739fb711c27f6e1393366",
        remote = "https://github.com/googleapis/googleapis.git",
        build_file_content = """
load("@protobuf_bzl//:protobuf.bzl", "cc_proto_library", "py_proto_library")

filegroup(
    name = "http_api_protos_src",
    srcs = [
        "google/api/annotations.proto",
        "google/api/http.proto",
    ],
    visibility = ["//visibility:public"],
)

cc_proto_library(
    name = "http_api_protos",
    srcs = [
        ":http_apis_protos_src",
    ],
    default_runtime = "//external:protobuf",
    protoc = "//external:protoc",
    visibility = ["//visibility:public"],
    deps = ["@protobuf_bzl//:cc_wkt_protos"],
)

py_proto_library(
    name = "http_api_protos_py",
    srcs = [
        ":http_apis_protos_src",
    ],
    include = ".",
    default_runtime = "//external:protobuf_python",
    protoc = "//external:protoc",
    visibility = ["//visibility:public"],
    deps = ["//external:protobuf_python"],
)
        """,
    )
