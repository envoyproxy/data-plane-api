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

bazel --batch build ${BAZEL_BUILD_OPTIONS} //api --aspects \
  tools/protodoc/protodoc.bzl%proto_doc_aspect --output_groups=rst --action_env=CPROFILE_ENABLED

# These are the protos we want to put in docs, this list will grow.
# TODO(htuch): Factor this out of this script.
PROTO_RST="
  /api/address/api/address.proto.rst
  /api/base/api/base.proto.rst
  /api/bootstrap/api/bootstrap.proto.rst
  /api/cds/api/cds.proto.rst
  /api/config_source/api/config_source.proto.rst
  /api/discovery/api/discovery.proto.rst
  /api/eds/api/eds.proto.rst
  /api/grpc_service/api/grpc_service.proto.rst
  /api/health_check/api/health_check.proto.rst
  /api/lds/api/lds.proto.rst
  /api/metrics/api/metrics_service.proto.rst
  /api/rds/api/rds.proto.rst
  /api/rls/api/rls.proto.rst
  /api/sds/api/sds.proto.rst
  /api/stats/api/stats.proto.rst
  /api/trace/api/trace.proto.rst
  /api/filter/accesslog/accesslog/api/filter/accesslog/accesslog.proto.rst
  /api/filter/fault/api/filter/fault.proto.rst
  /api/filter/http/buffer/api/filter/http/buffer.proto.rst
  /api/filter/http/fault/api/filter/http/fault.proto.rst
  /api/filter/http/gzip/api/filter/http/gzip.proto.rst
  /api/filter/http/health_check/api/filter/http/health_check.proto.rst
  /api/filter/http/lua/api/filter/http/lua.proto.rst
  /api/filter/http/rate_limit/api/filter/http/rate_limit.proto.rst
  /api/filter/http/router/api/filter/http/router.proto.rst
  /api/filter/http/squash/api/filter/http/squash.proto.rst
  /api/filter/http/transcoder/api/filter/http/transcoder.proto.rst
  /api/filter/network/client_ssl_auth/api/filter/network/client_ssl_auth.proto.rst
  /api/filter/network/http_connection_manager/api/filter/network/http_connection_manager.proto.rst
  /api/filter/network/mongo_proxy/api/filter/network/mongo_proxy.proto.rst
  /api/filter/network/rate_limit/api/filter/network/rate_limit.proto.rst
  /api/filter/network/redis_proxy/api/filter/network/redis_proxy.proto.rst
  /api/filter/network/tcp_proxy/api/filter/network/tcp_proxy.proto.rst
  /api/protocol/api/protocol.proto.rst
  /api/rds/api/rds.proto.rst
"

# Dump all the generated RST so they can be added to PROTO_RST easily.
find -L bazel-bin -name "*.proto.rst"

# Only copy in the protos we care about and know how to deal with in protodoc.
for p in $PROTO_RST
do
  DEST="${GENERATED_RST_DIR}/api-v2/$(sed -e 's#/api.*/api/##' <<< "$p")"
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
