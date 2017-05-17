workspace(name = "envoy_api")

new_git_repository(
    name = "googleapis",
    # Head of master at 5/14.
    commit = "5c6df0cd18c6a429eab739fb711c27f6e1393366",
    remote = "https://github.com/googleapis/googleapis.git",
    build_file_content = """
load("@protobuf//:protobuf.bzl", "cc_proto_library")

cc_proto_library(
    name = "http_api_protos",
    srcs = [
        "google/api/annotations.proto",
        "google/api/http.proto",
    ],
    default_runtime = "@protobuf//:protobuf",
    protoc = "@protobuf//:protoc",
    visibility = ["//visibility:public"],
    deps = ["@protobuf//:cc_wkt_protos"],
)
    """,
)

git_repository(
    name = "protobuf",
    # HEAD of master 5/8.
    commit = "455b61c6b0f39ac269b26969877dd3c6f3e32270",
    remote = "https://github.com/google/protobuf.git",
)
