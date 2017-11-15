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
  tools/protodoc/protodoc.bzl%proto_doc_aspect --output_groups=rst

# These are the protos we want to put in docs, this list will grow.
# TODO(htuch): Factor this out of this script.
PROTO_RST="
  /api/address/api/address.proto.rst
  /api/base/api/base.proto.rst
  /api/filter/fault/api/filter/fault.proto.rst
  /api/filter/network/mongo_proxy/api/filter/network/mongo_proxy.proto.rst
"

# Dump all the generated RST so they can be added to PROTO_RST easily.
find -L bazel-bin -name "*.proto.rst"

# Only copy in the protos we care about and know how to deal with in protodoc.
for p in $PROTO_RST
do
  DEST="${GENERATED_RST_DIR}/api-v2/$(sed -e 's#/api.*/api/##' <<< "$p")"
  mkdir -p "$(dirname "${DEST}")"
  cp -f bazel-bin/"${p}" "${DEST}"
done

rsync -av "${SCRIPT_DIR}"/root/ "${SCRIPT_DIR}"/conf.py "${GENERATED_RST_DIR}"

BUILD_SHA=$(git rev-parse HEAD)
[[ -z "${ENVOY_DOCS_VERSION_STRING}" ]] && ENVOY_DOCS_VERSION_STRING=data-plane-api-"${BUILD_SHA:0:6}"
[[ -z "${ENVOY_DOCS_RELEASE_LEVEL}" ]] && ENVOY_DOCS_RELEASE_LEVEL=pre-release

export ENVOY_DOCS_VERSION_STRING ENVOY_DOCS_RELEASE_LEVEL
sphinx-build -W -b html "${GENERATED_RST_DIR}" "${DOCS_OUTPUT_DIR}"
