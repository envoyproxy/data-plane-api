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
  # TODO(htuch): There is a snafu with unsandboxed Bazel, where it will generate
  # the .proto for leaf dependencies multiple times in the same location,
  # causing file permission errors (Bazel outputs are read-only). Need figure
  # out how to handle this properly before we can build //api completely, only
  # doing address.proto.rst for now.
  bazel --batch build ${BAZEL_BUILD_OPTIONS} --aspects tools/protodoc/protodoc.bzl%proto_doc_aspect  \
    --output_groups=rst //api:address
else
  echo "Invalid do_ci.sh target. The only valid target is bazel.build."
  exit 1
fi
