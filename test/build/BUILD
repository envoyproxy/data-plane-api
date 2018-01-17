load("//bazel:api_build_system.bzl", "api_cc_test", "api_go_test")

licenses(["notice"])  # Apache 2

api_cc_test(
    name = "build_test",
    srcs = ["build_test.cc"],
    proto_deps = [
        "//envoy/api/v2:hds",
        "//envoy/api/v2:metrics",
        "//envoy/api/v2:rls",
        "//envoy/api/v2/discovery:ads",
        "//envoy/api/v2/discovery:cds",
        "//envoy/api/v2/discovery:eds",
        "//envoy/api/v2/discovery:lds",
        "//envoy/api/v2/discovery:rds",
        "//envoy/api/v2/filter/accesslog",
    ],
)

api_go_test(
    name = "go_build_test",
    size = "small",
    srcs = ["go_build_test.go"],
    importpath = "go_build_test",
    deps = [
        "//envoy/api/v2:hds_go_grpc",
        "//envoy/api/v2:rls_go_grpc",
        "//envoy/api/v2/bootstrap:bootstrap_go_proto",
        "//envoy/api/v2/cert:cert_go_proto",
        "//envoy/api/v2/discovery:ads_go_grpc",
        "//envoy/api/v2/discovery:cds_go_grpc",
        "//envoy/api/v2/discovery:eds_go_grpc",
        "//envoy/api/v2/discovery:lds_go_grpc",
        "//envoy/api/v2/discovery:rds_go_grpc",
        "//envoy/api/v2/discovery:sds_go_grpc",
    ],
)
