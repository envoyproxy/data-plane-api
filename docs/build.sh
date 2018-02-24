#!/bin/bash

set -e

SCRIPT_DIR=$(dirname "$0")
BUILD_DIR=build_docs
[[ -z "${DOCS_OUTPUT_DIR}" ]] && DOCS_OUTPUT_DIR=generated/docs
[[ -z "${GENERATED_RST_DIR}" ]] && GENERATED_RST_DIR=generated/rst

rm -rf "${DOCS_OUTPUT_DIR}"
mkdir -p "${DOCS_OUTPUT_DIR}"

rm -rf "${GENERATED_RST_DIR}"
mkdir -p "${GENERATED_RST_DIR}"

if [ ! -d "${BUILD_DIR}"/venv ]; then
  virtualenv "${BUILD_DIR}"/venv --no-site-packages
  "${BUILD_DIR}"/venv/bin/pip install -r "${SCRIPT_DIR}"/requirements.txt
fi

source "${BUILD_DIR}"/venv/bin/activate

bazel --batch build ${BAZEL_BUILD_OPTIONS} //docs:protos --aspects \
  tools/protodoc/protodoc.bzl%proto_doc_aspect --output_groups=rst --action_env=CPROFILE_ENABLED

# These are the protos we want to put in docs, this list will grow.
# TODO(htuch): Factor this out of this script.
PROTO_RST="
  /envoy/api/v2/core/address/envoy/api/v2/core/address.proto.rst
  /envoy/api/v2/core/base/envoy/api/v2/core/base.proto.rst
  /envoy/api/v2/core/config_source/envoy/api/v2/core/config_source.proto.rst
  /envoy/api/v2/core/grpc_service/envoy/api/v2/core/grpc_service.proto.rst
  /envoy/api/v2/core/health_check/envoy/api/v2/core/health_check.proto.rst
  /envoy/api/v2/core/protocol/envoy/api/v2/core/protocol.proto.rst
  /envoy/api/v2/auth/cert/envoy/api/v2/auth/cert.proto.rst
  /envoy/api/v2/eds/envoy/api/v2/eds.proto.rst
  /envoy/api/v2/endpoint/endpoint/envoy/api/v2/endpoint/endpoint.proto.rst
  /envoy/api/v2/cds/envoy/api/v2/cds.proto.rst
  /envoy/api/v2/cluster/outlier_detection/envoy/api/v2/cluster/outlier_detection.proto.rst
  /envoy/api/v2/cluster/circuit_breaker/envoy/api/v2/cluster/circuit_breaker.proto.rst
  /envoy/api/v2/rds/envoy/api/v2/rds.proto.rst
  /envoy/api/v2/route/route/envoy/api/v2/route/route.proto.rst
  /envoy/api/v2/lds/envoy/api/v2/lds.proto.rst
  /envoy/api/v2/listener/listener/envoy/api/v2/listener/listener.proto.rst
  /envoy/api/v2/ratelimit/ratelimit/envoy/api/v2/ratelimit/ratelimit.proto.rst
  /envoy/config/bootstrap/v2/bootstrap/envoy/config/bootstrap/v2/bootstrap.proto.rst
  /envoy/api/v2/discovery/envoy/api/v2/discovery.proto.rst
  /envoy/config/ratelimit/v2/rls/envoy/config/ratelimit/v2/rls.proto.rst
  /envoy/config/metrics/v2/metrics_service/envoy/config/metrics/v2/metrics_service.proto.rst
  /envoy/config/metrics/v2/stats/envoy/config/metrics/v2/stats.proto.rst
  /envoy/config/trace/v2/trace/envoy/config/trace/v2/trace.proto.rst
  /envoy/config/filter/accesslog/v2/accesslog/envoy/config/filter/accesslog/v2/accesslog.proto.rst
  /envoy/config/filter/fault/v2/fault/envoy/config/filter/fault/v2/fault.proto.rst
  /envoy/config/filter/http/buffer/v2/buffer/envoy/config/filter/http/buffer/v2/buffer.proto.rst
  /envoy/config/filter/http/fault/v2/fault/envoy/config/filter/http/fault/v2/fault.proto.rst
  /envoy/config/filter/http/gzip/v2/gzip/envoy/config/filter/http/gzip/v2/gzip.proto.rst
  /envoy/config/filter/http/health_check/v2/health_check/envoy/config/filter/http/health_check/v2/health_check.proto.rst
  /envoy/config/filter/http/ip_tagging/v2/ip_tagging/envoy/config/filter/http/ip_tagging/v2/ip_tagging.proto.rst
  /envoy/config/filter/http/lua/v2/lua/envoy/config/filter/http/lua/v2/lua.proto.rst
  /envoy/config/filter/http/rate_limit/v2/rate_limit/envoy/config/filter/http/rate_limit/v2/rate_limit.proto.rst
  /envoy/config/filter/http/router/v2/router/envoy/config/filter/http/router/v2/router.proto.rst
  /envoy/config/filter/http/squash/v2/squash/envoy/config/filter/http/squash/v2/squash.proto.rst
  /envoy/config/filter/http/transcoder/v2/transcoder/envoy/config/filter/http/transcoder/v2/transcoder.proto.rst
  /envoy/config/filter/network/client_ssl_auth/v2/client_ssl_auth/envoy/config/filter/network/client_ssl_auth/v2/client_ssl_auth.proto.rst
  /envoy/config/filter/network/http_connection_manager/v2/http_connection_manager/envoy/config/filter/network/http_connection_manager/v2/http_connection_manager.proto.rst
  /envoy/config/filter/network/mongo_proxy/v2/mongo_proxy/envoy/config/filter/network/mongo_proxy/v2/mongo_proxy.proto.rst
  /envoy/config/filter/network/rate_limit/v2/rate_limit/envoy/config/filter/network/rate_limit/v2/rate_limit.proto.rst
  /envoy/config/filter/network/redis_proxy/v2/redis_proxy/envoy/config/filter/network/redis_proxy/v2/redis_proxy.proto.rst
  /envoy/config/filter/network/tcp_proxy/v2/tcp_proxy/envoy/config/filter/network/tcp_proxy/v2/tcp_proxy.proto.rst
  /envoy/type/percent/envoy/type/percent.proto.rst
  /envoy/type/range/envoy/type/range.proto.rst
"

# Dump all the generated RST so they can be added to PROTO_RST easily.
find -L bazel-bin -name "*.proto.rst"

# Only copy in the protos we care about and know how to deal with in protodoc.
for p in $PROTO_RST
do
  DEST="${GENERATED_RST_DIR}/api-v2/$(sed -e 's#/envoy\/.*/envoy/##' <<< "$p")"
  mkdir -p "$(dirname "${DEST}")"
  cp -f bazel-bin/"${p}" "$(dirname "${DEST}")"
  [ -n "${CPROFILE_ENABLED}" ] && cp -f bazel-bin/"${p}".profile "$(dirname "${DEST}")"
done

rsync -av "${SCRIPT_DIR}"/root/ "${SCRIPT_DIR}"/conf.py "${GENERATED_RST_DIR}"

BUILD_SHA=$(git rev-parse HEAD)
VERSION_NUM=$(cat VERSION)
[[ -z "${ENVOY_DOCS_VERSION_STRING}" ]] && ENVOY_DOCS_VERSION_STRING="${VERSION_NUM}"-data-plane-api-"${BUILD_SHA:0:6}"
[[ -z "${ENVOY_DOCS_RELEASE_LEVEL}" ]] && ENVOY_DOCS_RELEASE_LEVEL=pre-release

export ENVOY_DOCS_VERSION_STRING ENVOY_DOCS_RELEASE_LEVEL
sphinx-build -W -b html "${GENERATED_RST_DIR}" "${DOCS_OUTPUT_DIR}"
