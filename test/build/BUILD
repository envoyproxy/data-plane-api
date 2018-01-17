load("//bazel:api_build_system.bzl", "api_cc_test", "api_go_test")

licenses(["notice"])  # Apache 2

api_cc_test(
    name = "build_test",
    srcs = ["build_test.cc"],
    proto_deps = [
        "//api:hds",
        "//api:metrics",
        "//api:rls",
        "//api/discovery:ads",
        "//api/discovery:cds",
        "//api/discovery:eds",
        "//api/discovery:lds",
        "//api/discovery:rds",
        "//api/filter/accesslog",
    ],
)

api_go_test(
    name = "go_build_test",
    size = "small",
    srcs = ["go_build_test.go"],
    importpath = "go_build_test",
    deps = [
        "//api:hds_go_grpc",
        "//api:rls_go_grpc",
        "//api/bootstrap:bootstrap_go_proto",
        "//api/cert:cert_go_proto",
        "//api/discovery:ads_go_grpc",
        "//api/discovery:cds_go_grpc",
        "//api/discovery:eds_go_grpc",
        "//api/discovery:sds_go_grpc",
        "//api/discovery:lds_go_grpc",
        "//api/discovery:rds_go_grpc",
    ],
)
