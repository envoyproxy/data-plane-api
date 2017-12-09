load("//bazel:api_build_system.bzl", "api_proto_library")
load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_proto_library", "go_grpc_library")

licenses(["notice"])  # Apache 2

go_proto_library(
    name = "any_go_proto",
    importpath = "github.com/golang/protobuf/ptypes/any",
    proto = "@com_google_protobuf//:any_proto",
    visibility = ["//visibility:public"],
)

go_proto_library(
    name = "duration_go_proto",
    importpath = "github.com/golang/protobuf/ptypes/duration",
    proto = "@com_google_protobuf//:duration_proto",
    visibility = ["//visibility:public"],
)

go_proto_library(
    name = "struct_go_proto",
    importpath = "github.com/golang/protobuf/ptypes/struct",
    proto = "@com_google_protobuf//:struct_proto",
    visibility = ["//visibility:public"],
)

go_proto_library(
    name = "timestamp_go_proto",
    importpath = "github.com/golang/protobuf/ptypes/timestamp",
    proto = "@com_google_protobuf//:timestamp_proto",
    visibility = ["//visibility:public"],
)

go_proto_library(
    name = "wrappers_go_proto",
    importpath = "github.com/golang/protobuf/ptypes/wrappers",
    proto = "@com_google_protobuf//:wrappers_proto",
    visibility = ["//visibility:public"],
)

api_proto_library(
    name = "address",
    srcs = ["address.proto"],
)

go_proto_library(
    name = "address_go_proto",
    importpath = "github.com/envoyproxy/data-plane-api/api/address",
    proto = ":address",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_gogo_protobuf//:gogo_proto_go",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
)

api_proto_library(
    name = "base",
    srcs = ["base.proto"],
    deps = [":address"],
)

go_proto_library(
    name = "base_go_proto",
    importpath = "github.com/envoyproxy/data-plane-api/api/base",
    proto = ":base",
    visibility = ["//visibility:public"],
    deps = [
        ":address_go_proto",
        "@com_github_gogo_protobuf//:gogo_proto_go",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
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
        ":trace",
    ],
)

go_proto_library(
    name = "bootstrap_go_proto",
    importpath = "github.com/envoyproxy/data-plane-api/api/bootstrap",
    proto = ":bootstrap",
    visibility = ["//visibility:public"],
    deps = [
        ":address_go_proto",
        ":base_go_proto",
        ":cds_go_grpc",
        ":lds_go_grpc",
        ":sds_go_grpc",
        ":stats_go_proto",
        ":trace_go_proto",
        "@com_github_gogo_protobuf//:gogo_proto_go",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
)

api_proto_library(
    name = "health_check",
    srcs = ["health_check.proto"],
    deps = [":base"],
)

go_proto_library(
    name = "health_check_go_proto",
    importpath = "github.com/envoyproxy/data-plane-api/api/health_check",
    proto = ":health_check",
    visibility = ["//visibility:public"],
    deps = [
        ":base_go_proto",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
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

go_grpc_library(
    name = "cds_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/cds",
    proto = ":cds",
    visibility = ["//visibility:public"],
    deps = [
        ":address_go_proto",
        ":base_go_proto",
        ":discovery_go_grpc",
        ":health_check_go_proto",
        ":protocol_go_proto",
        ":sds_go_grpc",
        "@com_github_gogo_protobuf//:gogo_proto_go",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
        "@googleapis//:http_api_go_proto",
    ],
)

api_proto_library(
    name = "discovery",
    srcs = ["discovery.proto"],
    has_services = 1,
    deps = [":base"],
)

go_grpc_library(
    name = "discovery_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/discovery",
    proto = ":discovery",
    visibility = ["//visibility:public"],
    deps = [
        ":base_go_proto",
        "@com_github_golang_protobuf//ptypes/any:go_default_library",
    ],
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

go_grpc_library(
    name = "eds_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/eds",
    proto = ":eds",
    visibility = ["//visibility:public"],
    deps = [
        ":address_go_proto",
        ":base_go_proto",
        ":discovery_go_grpc",
        ":health_check_go_proto",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
        "@googleapis//:http_api_go_proto",
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

go_grpc_library(
    name = "hds_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/hds",
    proto = ":hds",
    visibility = ["//visibility:public"],
    deps = [
        ":base_go_proto",
        ":health_check_go_proto",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@googleapis//:http_api_go_proto",
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

go_grpc_library(
    name = "lds_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/lds",
    proto = ":lds",
    visibility = ["//visibility:public"],
    deps = [
        ":address_go_proto",
        ":base_go_proto",
        ":discovery_go_grpc",
        ":sds_go_grpc",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
        "@googleapis//:http_api_go_proto",
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

go_proto_library(
    name = "protocol_go_proto",
    importpath = "github.com/envoyproxy/data-plane-api/api/protocol",
    proto = ":protocol",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
)

api_proto_library(
    name = "rls",
    srcs = ["rls.proto"],
    has_services = 1,
)

go_grpc_library(
    name = "rls_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/rls",
    proto = ":rls",
    visibility = ["//visibility:public"],
    deps = [
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
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

go_grpc_library(
    name = "rds_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/rds",
    proto = ":rds",
    visibility = ["//visibility:public"],
    deps = [
        ":auth_go_proto",
        ":base_go_proto",
        ":discovery_go_grpc",
        "@com_github_gogo_protobuf//:gogo_proto_go",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
        "@googleapis//:http_api_go_proto",
    ],
)

go_grpc_library(
    name = "rds_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/rds",
    proto = ":rds",
    visibility = ["//visibility:public"],
    deps = [
        ":auth_go_proto",
        ":base_go_proto",
        ":discovery_go_grpc",
        "@com_github_gogo_protobuf//:gogo_proto_go",
        "@com_github_golang_protobuf//ptypes/duration:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
        "@googleapis//:http_api_go_proto",
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

go_grpc_library(
    name = "sds_go_grpc",
    importpath = "github.com/envoyproxy/data-plane-api/api/sds",
    proto = ":sds",
    visibility = ["//visibility:public"],
    deps = [
        ":base_go_proto",
        ":discovery_go_grpc",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
        "@googleapis//:http_api_go_proto",
    ],
)

api_proto_library(
    name = "stats",
    srcs = ["stats.proto"],
    deps = [
        ":address",
    ],
)

go_proto_library(
    name = "stats_go_proto",
    importpath = "github.com/envoyproxy/data-plane-api/api/stats",
    proto = ":stats",
    visibility = ["//visibility:public"],
    deps = [
        ":address_go_proto",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
)

api_proto_library(
    name = "trace",
    srcs = ["trace.proto"],
)

go_proto_library(
    name = "trace_go_proto",
    importpath = "github.com/envoyproxy/data-plane-api/api/trace",
    proto = ":trace",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_lyft_protoc_gen_validate//validate:go_default_library",
    ],
)

api_proto_library(
    name = "auth",
    srcs = ["auth.proto"],
    deps = [
        ":sds",
    ],
)

go_proto_library(
    name = "auth_go_proto",
    importpath = "github.com/envoyproxy/data-plane-api/auth",
    proto = ":auth",
    visibility = ["//visibility:public"],
    deps = [
        "//api:address_go_proto",
        "//api:sds_go_grpc",
        "@com_github_golang_protobuf//ptypes/struct:go_default_library",
        "@com_github_golang_protobuf//ptypes/timestamp:go_default_library",
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
        "//api/filter/http:fault",
        "//api/filter/http:health_check",
        "//api/filter/http:lua",
        "//api/filter/http:rate_limit",
        "//api/filter/http:router",
        "//api/filter/http:squash",
        "//api/filter/http:transcoder",
        "//api/filter/network:client_ssl_auth",
        "//api/filter/network:http_connection_manager",
        "//api/filter/network:mongo_proxy",
        "//api/filter/network:rate_limit",
        "//api/filter/network:redis_proxy",
        "//api/filter/network:tcp_proxy",
    ],
)
