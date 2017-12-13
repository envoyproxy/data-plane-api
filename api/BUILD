load("//bazel:api_build_system.bzl", "api_proto_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "address",
    srcs = ["address.proto"],
)

api_proto_library(
    name = "auth",
    srcs = [
        "auth.proto",
        "external_auth.proto",
    ],
    deps = [
        ":sds",
        ":address",
    ],
)

api_proto_library(
    name = "base",
    srcs = ["base.proto"],
    deps = [":address"],
)

api_proto_library(
    name = "bootstrap",
    srcs = ["bootstrap.proto"],
    deps = [
        ":address",
        ":base",
        ":cds",
        ":lds",
        ":sds",
        ":stats",
    ],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    deps = [":base"],
)

api_proto_library(
    name = "cds",
    srcs = ["cds.proto"],
    has_services = 1,
    deps = [
        ":address",
        ":base",
        ":discovery",
        ":health_check",
        ":protocol",
        ":sds",
    ],
)

api_proto_library(
    name = "discovery",
    srcs = ["discovery.proto"],
    has_services = 1,
    deps = [":base"],
)

api_proto_library(
    name = "eds",
    srcs = ["eds.proto"],
    has_services = 1,
    deps = [
        ":address",
        ":base",
        ":discovery",
        ":health_check",
    ],
)

api_proto_library(
    name = "hds",
    srcs = ["hds.proto"],
    has_services = 1,
    deps = [
        ":base",
        ":health_check",
    ],
)

api_proto_library(
    name = "lds",
    srcs = ["lds.proto"],
    has_services = 1,
    deps = [
        ":address",
        ":base",
        ":discovery",
        ":sds",
    ],
)

api_proto_library(
    name = "metrics",
    srcs = ["metrics_service.proto"],
    has_services = 1,
    require_py = 0,
    deps = [
        ":base",
        "@promotheus_metrics_model//:client_model",
    ],
)

api_proto_library(
    name = "protocol",
    srcs = ["protocol.proto"],
)

api_proto_library(
    name = "rls",
    srcs = ["rls.proto"],
    has_services = 1,
)

api_proto_library(
    name = "rds",
    srcs = ["rds.proto"],
    has_services = 1,
    deps = [
        ":auth",
        ":base",
        ":discovery",
    ],
)

api_proto_library(
    name = "sds",
    srcs = ["sds.proto"],
    has_services = 1,
    deps = [
        ":base",
        ":discovery",
    ],
)

api_proto_library(
    name = "stats",
    srcs = ["stats.proto"],
    deps = [
        ":address",
    ],
)

# TODO(htuch): Grow this to cover everything we want to generate docs for, so we can just invoke
# bazel build //api --aspects tools/protodoc/protodoc.bzl%proto_doc_aspect  --output_groups=rst
proto_library(
    name = "api",
    deps = [
        ":bootstrap",
        ":cds",
        ":eds",
        ":lds",
        ":protocol",
        ":rds",
        ":rls",
        "//api/filter/accesslog",
        "//api/filter/http:buffer",
        "//api/filter/http:fault",
        "//api/filter/http:health_check",
        "//api/filter/http:lua",
        "//api/filter/http:rate_limit",
        "//api/filter/http:router",
        "//api/filter/http:transcoder",
        "//api/filter/network:client_ssl_auth",
        "//api/filter/network:http_connection_manager",
        "//api/filter/network:mongo_proxy",
        "//api/filter/network:rate_limit",
        "//api/filter/network:redis_proxy",
        "//api/filter/network:tcp_proxy",
    ],
)
