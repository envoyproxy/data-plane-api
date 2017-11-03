licenses(["notice"])  # Apache 2

py_binary(
    name = "protodoc",
    srcs = ["protodoc.py"],
    deps = [
        "@com_lyft_protoc_gen_validate//validate:validate_py",
        "@com_google_protobuf//:protobuf_python",
    ],
    visibility = ["//visibility:public"],
)
