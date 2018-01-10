load("//bazel:api_build_system.bzl", "api_proto_library", "api_go_proto_library", "api_go_grpc_library")

licenses(["notice"])  # Apache 2

api_proto_library(
    name = "address",
    srcs = ["address.proto"],
)

api_go_proto_library(
    name = "address",
    proto = ":address",
)

api_proto_library(
    name = "base",
    srcs = ["base.proto"],
    deps = [":address"],
)

api_go_proto_library(
    name = "base",
    proto = ":base",
    deps = [":address_go_proto"],
)

api_proto_library(
    name = "bootstrap",
    srcs = ["bootstrap.proto"],
    deps = [
        ":address",
        ":base",
        ":cds",
        ":config_source",
        ":grpc_service",
        ":lds",
        ":sds",
        ":stats",
        ":trace",
    ],
)

api_go_proto_library(
    name = "bootstrap",
    proto = ":bootstrap",
    deps = [
        ":address_go_proto",
        ":base_go_proto",
        ":cds_go_grpc",
        ":config_source_go_proto",
        ":grpc_service_go_proto",
        ":lds_go_grpc",
        ":sds_go_grpc",
        ":stats_go_proto",
        ":trace_go_proto",
    ],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    deps = [":base"],
)

api_go_proto_library(
    name = "health_check",
    proto = ":health_check",
    deps = [":base_go_proto"],
)

api_proto_library(
    name = "cds",
    srcs = ["cds.proto"],
    has_services = 1,
    deps = [
        ":address",
        ":base",
        ":config_source",
        ":discovery",
        ":health_check",
        ":protocol",
        ":sds",
    ],
)

api_go_grpc_library(
    name = "cds",
    proto = ":cds",
    deps = [
        ":address_go_proto",
        ":base_go_proto",
        ":config_source_go_proto",
        ":discovery_go_grpc",
        ":health_check_go_proto",
        ":protocol_go_proto",
        ":sds_go_grpc",
    ],
)

api_proto_library(
    name = "config_source",
    srcs = ["config_source.proto"],
    deps = [
        ":base",
        ":grpc_service",
    ],
)

api_go_proto_library(
    name = "config_source",
    proto = ":config_source",
    deps = [
        ":base_go_proto",
        ":grpc_service_go_proto",
    ],
)

api_proto_library(
    name = "discovery",
    srcs = ["discovery.proto"],
    has_services = 1,
    deps = [":base"],
)

api_go_grpc_library(
    name = "discovery",
    proto = ":discovery",
    deps = [":base_go_proto"],
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

api_go_grpc_library(
    name = "eds",
    proto = ":eds",
    deps = [
        ":address_go_proto",
        ":base_go_proto",
        ":discovery_go_grpc",
        ":health_check_go_proto",
    ],
)

api_proto_library(
    name = "grpc_service",
    srcs = ["grpc_service.proto"],
    deps = [":base"],
)

api_go_proto_library(
    name = "grpc_service",
    proto = ":grpc_service",
    deps = [":base_go_proto"],
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

api_go_grpc_library(
    name = "hds",
    proto = ":hds",
    deps = [
        ":base_go_proto",
        ":health_check_go_proto",
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

api_go_grpc_library(
    name = "lds",
    proto = ":lds",
    deps = [
        ":address_go_proto",
        ":base_go_proto",
        ":discovery_go_grpc",
        ":sds_go_grpc",
    ],
)

api_proto_library(
    name = "metrics",
    srcs = ["metrics_service.proto"],
    has_services = 1,
    require_py = 0,
    deps = [
        ":base",
        ":grpc_service",
        "@promotheus_metrics_model//:client_model",
    ],
)

api_proto_library(
    name = "protocol",
    srcs = ["protocol.proto"],
)

api_go_proto_library(
    name = "protocol",
    proto = ":protocol",
)

api_proto_library(
    name = "rls",
    srcs = ["rls.proto"],
    has_services = 1,
)

api_go_grpc_library(
    name = "rls",
    proto = ":rls",
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

api_go_grpc_library(
    name = "rds",
    proto = ":rds",
    deps = [
        ":auth_go_proto",
        ":base_go_proto",
        ":discovery_go_grpc",
    ],
)

api_proto_library(
    name = "sds",
    srcs = ["sds.proto"],
    has_services = 1,
    deps = [
        ":base",
        ":config_source",
        ":discovery",
    ],
)

api_go_grpc_library(
    name = "sds",
    proto = ":sds",
    deps = [
        ":base_go_proto",
        ":config_source_go_proto",
        ":discovery_go_grpc",
    ],
)

api_proto_library(
    name = "stats",
    srcs = ["stats.proto"],
    deps = [
        ":address",
    ],
)

api_go_proto_library(
    name = "stats",
    proto = ":stats",
    deps = [
        ":address_go_proto",
    ],
)

api_proto_library(
    name = "trace",
    srcs = ["trace.proto"],
)

api_go_proto_library(
    name = "trace",
    proto = ":trace",
)

api_proto_library(
    name = "auth",
    srcs = ["auth.proto"],
    deps = [
        ":sds",
    ],
)

api_go_proto_library(
    name = "auth",
    proto = ":auth",
    deps = [
        "//api:address_go_proto",
        "//api:sds_go_grpc",
        "@googleapis//:rpc_status_go_proto",
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
        "//api/filter/http:ext_authz",
        "//api/filter/http:fault",
        "//api/filter/http:health_check",
        "//api/filter/http:lua",
        "//api/filter/http:rate_limit",
        "//api/filter/http:router",
        "//api/filter/http:squash",
        "//api/filter/http:transcoder",
        "//api/filter/network:client_ssl_auth",
        "//api/filter/network:ext_authz",
        "//api/filter/network:http_connection_manager",
        "//api/filter/network:mongo_proxy",
        "//api/filter/network:rate_limit",
        "//api/filter/network:redis_proxy",
        "//api/filter/network:tcp_proxy",
    ],
)
