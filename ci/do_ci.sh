#!/bin/bash

# Run a CI build/test target, e.g. docs, asan.

set -e

. "$(dirname "$0")"/build_setup.sh

echo "building using ${NUM_CPUS} CPUs"

if [[ "$1" == "bazel.test" ]]; then
  echo "bazel building and testing..."
  bazel --batch build ${BAZEL_BUILD_OPTIONS} //api/...
  bazel --batch test ${BAZEL_TEST_OPTIONS} //test/... //tools/...
  exit 0
elif [[ "$1" == "bazel.docs" ]]; then
  echo "generating docs..."
  bazel --batch build ${BAZEL_BUILD_OPTIONS} --aspects tools/protodoc/protodoc.bzl%proto_doc_aspect  \
    --output_groups=rst //api
else
  echo "Invalid do_ci.sh target. The only valid target is bazel.build."
  exit 1
fi
