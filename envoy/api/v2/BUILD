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

# TODO(htuch): Grow this to cover everything we want to generate docs for, so we can just invoke
# bazel build //envoy/api/v2:api --aspects tools/protodoc/protodoc.bzl%proto_doc_aspect  --output_groups=rst
proto_library(
    name = "api",
    deps = [
        ":protocol",
        ":rls",
        "//envoy/api/v2/bootstrap",
        "//envoy/api/v2/cluster",
        "//envoy/api/v2/cluster:circuit_breaker",
        "//envoy/api/v2/cluster:outlier_detection",
        "//envoy/api/v2/discovery",
        "//envoy/api/v2/filter/accesslog",
        "//envoy/api/v2/filter/http",
        "//envoy/api/v2/filter/network",
        "//envoy/api/v2/listener",
        "//envoy/api/v2/monitoring:metrics",
        "//envoy/api/v2/route",
    ],
)
