load("//bazel:api_build_system.bzl", "api_cc_test", "api_proto_library")

licenses(["notice"])  # Apache 2

api_cc_test(
    name = "pgv_test",
    srcs = ["pgv_test.cc"],
    proto_deps = [
        "//envoy/api/v2:cds",
        "//envoy/api/v2:eds",
        "//envoy/api/v2:lds",
        "//envoy/api/v2:rds",
        "//envoy/api/v2/core:protocol",
        "//envoy/api/v2/filter/accesslog",
        "//envoy/api/v2/filter/http:buffer",
        "//envoy/api/v2/filter/http:fault",
        "//envoy/api/v2/filter/http:gzip",
        "//envoy/api/v2/filter/http:health_check",
        "//envoy/api/v2/filter/http:lua",
        "//envoy/api/v2/filter/http:router",
        "//envoy/api/v2/filter/http:squash",
        "//envoy/api/v2/filter/http:transcoder",
        "//envoy/api/v2/filter/network:http_connection_manager",
        "//envoy/api/v2/filter/network:mongo_proxy",
        "//envoy/api/v2/filter/network:redis_proxy",
        "//envoy/api/v2/filter/network:tcp_proxy",
        "//envoy/api/v2/listener",
        "//envoy/api/v2/route",
        "//envoy/config/bootstrap/v2:bootstrap",
    ],
)
