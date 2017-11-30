#!/bin/bash

# Run a CI build/test target, e.g. docs, asan.

set -e

# xlarge resource_class.
# See note: https://circleci.com/docs/2.0/configuration-reference/#resource_class for why we
# hard code this (basically due to how docker works).
export NUM_CPUS=8

. "$(dirname "$0")"/build_setup.sh

echo "building using ${NUM_CPUS} CPUs"

if [[ "$1" == "bazel.test" ]]; then
  echo "bazel building and testing..."
  bazel --batch build ${BAZEL_BUILD_OPTIONS} //api/...
  bazel --batch test ${BAZEL_TEST_OPTIONS} //test/... //tools/...
  exit 0
elif [[ "$1" == "bazel.docs" ]]; then
  echo "generating docs..."
  ./docs/build.sh
elif [[ "$1" == "fix_format" ]]; then
  echo "fix_format..."
  cd "${ENVOY_SRCDIR}"
  ./tools/check_format.py fix
  exit 0
elif [[ "$1" == "check_format" ]]; then
  echo "check_format..."
  cd "${ENVOY_SRCDIR}"
  ./tools/check_format.py check
  exit 0
else
  echo "Invalid do_ci.sh target. The only valid targets are bazel.{docs,test}."
  exit 1
fi
