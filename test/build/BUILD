load("//bazel:api_build_system.bzl", "api_cc_test", "api_go_test")

licenses(["notice"])  # Apache 2

api_cc_test(
    name = "build_test",
    srcs = ["build_test.cc"],
    proto_deps = [
        "//api:cds",
        "//api:discovery",
        "//api:eds",
        "//api:hds",
        "//api:lds",
        "//api:metrics",
        "//api:rds",
        "//api:rls",
        "//api/filter/accesslog",
    ],
)

api_go_test(
    name = "go_build_test",
    size = "small",
    srcs = ["go_build_test.go"],
    importpath = "go_build_test",
    deps = [
        "//api:bootstrap_go_proto",
        "//api:cds_go_grpc",
        "//api:discovery_go_grpc",
        "//api:eds_go_grpc",
        "//api:hds_go_grpc",
        "//api:lds_go_grpc",
        "//api:rds_go_grpc",
        "//api:rls_go_grpc",
        "//api:sds_go_grpc",
    ],
)
