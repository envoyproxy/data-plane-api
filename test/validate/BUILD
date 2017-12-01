load("//bazel:api_build_system.bzl", "api_cc_test", "api_proto_library")

licenses(["notice"])  # Apache 2

api_cc_test(
    name = "pgv_test",
    srcs = ["pgv_test.cc"],
    proto_deps = [
        "//api:bootstrap",
        "//api:cds",
        "//api:eds",
        "//api:lds",
        "//api:protocol",
        "//api:rds",
        "//api/filter/accesslog",
        "//api/filter/http:buffer",
        "//api/filter/http:fault",
        "//api/filter/http:health_check",
        "//api/filter/http:lua",
        "//api/filter/http:router",
        "//api/filter/http:transcoder",
        "//api/filter/network:http_connection_manager",
        "//api/filter/network:mongo_proxy",
        "//api/filter/network:redis_proxy",
        "//api/filter/network:tcp_proxy",
    ],
)
