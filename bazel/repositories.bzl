def api_dependencies():
    native.new_git_repository(
        name = "googleapis",
        # Head of master at 5/14.
        commit = "5c6df0cd18c6a429eab739fb711c27f6e1393366",
        remote = "https://github.com/googleapis/googleapis.git",
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
        """,
    )
