load("//bazel:api_build_system.bzl", "api_cc_test", "api_proto_library")

licenses(["notice"])  # Apache 2

api_cc_test(
    name = "pgv_test",
    srcs = ["pgv_test.cc"],
    proto_deps = [
        "//envoy/api/v2:cds",
        "//envoy/api/v2:eds",
        "//envoy/api/v2:lds",
        "//envoy/api/v2:protocol",
        "//envoy/api/v2:rds",
        "//envoy/config/bootstrap/v2:bootstrap",
        "//envoy/config/filter/v2/accesslog",
        "//envoy/config/filter/v2/http:buffer",
        "//envoy/config/filter/v2/http:fault",
        "//envoy/config/filter/v2/http:gzip",
        "//envoy/config/filter/v2/http:health_check",
        "//envoy/config/filter/v2/http:lua",
        "//envoy/config/filter/v2/http:router",
        "//envoy/config/filter/v2/http:squash",
        "//envoy/config/filter/v2/http:transcoder",
        "//envoy/config/filter/v2/network:http_connection_manager",
        "//envoy/config/filter/v2/network:mongo_proxy",
        "//envoy/config/filter/v2/network:redis_proxy",
        "//envoy/config/filter/v2/network:tcp_proxy",
    ],
)
