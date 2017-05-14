#!/bin/bash

# Run a CI build/test target, e.g. docs, asan.

set -e

. "$(dirname "$0")"/build_setup.sh

echo "building using ${NUM_CPUS} CPUs"

if [[ "$1" == "bazel.build" ]]; then
  echo "bazel build..."
  bazel --batch build ${BAZEL_BUILD_OPTIONS} //...
  exit 0
else
  echo "Invalid do_ci.sh target, see ci/README.md for valid targets."
  exit 1
fi
