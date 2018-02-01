licenses(["notice"])  # Apache 2

# Friends of the API proto libraries
package_group(
    name = "friends",
    packages = [
        "//envoy",
    ],
)

# TODO(htuch): Grow this to cover everything we want to generate docs for, so we can just invoke
# bazel build //envoy --aspects tools/protodoc/protodoc.bzl%proto_doc_aspect  --output_groups=rst
proto_library(
    name = "envoy",
    deps = [
        "//envoy/api/v2",
        "//envoy/api/v2:cds",
        "//envoy/api/v2/cluster:circuit_breaker",
        "//envoy/api/v2/cluster:outlier_detection",
        "//envoy/api/v2/filter/accesslog",
        "//envoy/api/v2/filter/http",
        "//envoy/api/v2/filter/network",
        "//envoy/api/v2/listener",
        "//envoy/api/v2/ratelimit",
        "//envoy/api/v2/route",
        "//envoy/config/bootstrap/v2:bootstrap",
        "//envoy/config/metrics/v2:metrics_service",
        "//envoy/config/metrics/v2:stats",
        "//envoy/config/ratelimit/v2:rls",
        "//envoy/config/trace/v2:trace",
        "//envoy/service/discovery/v2:ads",
        "//envoy/service/load_stats/v2:lrs",
        "//envoy/service/metrics/v2:metrics_service",
    ],
)
