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

bazel --batch build ${BAZEL_BUILD_OPTIONS} //envoy/api/v2:api --aspects \
  tools/protodoc/protodoc.bzl%proto_doc_aspect --output_groups=rst --action_env=CPROFILE_ENABLED

# These are the protos we want to put in docs, this list will grow.
# TODO(htuch): Factor this out of this script.
PROTO_RST="
  /envoy/api/v2/address/envoy/api/v2/address.proto.rst
  /envoy/api/v2/base/envoy/api/v2/base.proto.rst
  /envoy/api/v2/bootstrap/bootstrap/envoy/api/v2/bootstrap/bootstrap.proto.rst
  /envoy/api/v2/cert/cert/envoy/api/v2/cert/cert.proto.rst
  /envoy/api/v2/cluster/cluster/envoy/api/v2/cluster/cluster.proto.rst
  /envoy/api/v2/cluster/outlier_detection/envoy/api/v2/cluster/outlier_detection.proto.rst
  /envoy/api/v2/cluster/circuit_breaker/envoy/api/v2/cluster/circuit_breaker.proto.rst
  /envoy/api/v2/route/route/envoy/api/v2/route/route.proto.rst
  /envoy/api/v2/listener/listener/envoy/api/v2/listener/listener.proto.rst
  /envoy/api/v2/config_source/envoy/api/v2/config_source.proto.rst
  /envoy/api/v2/discovery/common/envoy/api/v2/discovery/common.proto.rst
  /envoy/api/v2/discovery/eds/envoy/api/v2/discovery/eds.proto.rst
  /envoy/api/v2/grpc_service/envoy/api/v2/grpc_service.proto.rst
  /envoy/api/v2/health_check/envoy/api/v2/health_check.proto.rst
  /envoy/api/v2/metrics/envoy/api/v2/metrics_service.proto.rst
  /envoy/api/v2/rls/envoy/api/v2/rls.proto.rst
  /envoy/api/v2/stats/envoy/api/v2/stats.proto.rst
  /envoy/api/v2/trace/envoy/api/v2/trace.proto.rst
  /envoy/api/v2/filter/accesslog/accesslog/envoy/api/v2/filter/accesslog/accesslog.proto.rst
  /envoy/api/v2/filter/fault/envoy/api/v2/filter/fault.proto.rst
  /envoy/api/v2/filter/http/buffer/envoy/api/v2/filter/http/buffer.proto.rst
  /envoy/api/v2/filter/http/fault/envoy/api/v2/filter/http/fault.proto.rst
  /envoy/api/v2/filter/http/health_check/envoy/api/v2/filter/http/health_check.proto.rst
  /envoy/api/v2/filter/http/lua/envoy/api/v2/filter/http/lua.proto.rst
  /envoy/api/v2/filter/http/rate_limit/envoy/api/v2/filter/http/rate_limit.proto.rst
  /envoy/api/v2/filter/http/router/envoy/api/v2/filter/http/router.proto.rst
  /envoy/api/v2/filter/http/squash/envoy/api/v2/filter/http/squash.proto.rst
  /envoy/api/v2/filter/http/transcoder/envoy/api/v2/filter/http/transcoder.proto.rst
  /envoy/api/v2/filter/network/client_ssl_auth/envoy/api/v2/filter/network/client_ssl_auth.proto.rst
  /envoy/api/v2/filter/network/http_connection_manager/envoy/api/v2/filter/network/http_connection_manager.proto.rst
  /envoy/api/v2/filter/network/mongo_proxy/envoy/api/v2/filter/network/mongo_proxy.proto.rst
  /envoy/api/v2/filter/network/rate_limit/envoy/api/v2/filter/network/rate_limit.proto.rst
  /envoy/api/v2/filter/network/redis_proxy/envoy/api/v2/filter/network/redis_proxy.proto.rst
  /envoy/api/v2/filter/network/tcp_proxy/envoy/api/v2/filter/network/tcp_proxy.proto.rst
  /envoy/api/v2/protocol/envoy/api/v2/protocol.proto.rst
"

# Dump all the generated RST so they can be added to PROTO_RST easily.
find -L bazel-bin -name "*.proto.rst"

# Only copy in the protos we care about and know how to deal with in protodoc.
for p in $PROTO_RST
do
  DEST="${GENERATED_RST_DIR}/api-v2/$(sed -e 's#/envoy\/api\/v2.*/envoy\/api\/v2/##' <<< "$p")"
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
