#!/bin/bash

# Configure environment variables for Bazel build and test.

set -e

NUM_CPUS=`grep -c ^processor /proc/cpuinfo`

export ENVOY_SRCDIR=/source

export BUILD_DIR=/build
if [[ ! -d "${BUILD_DIR}" ]]
then
  echo "${BUILD_DIR} mount missing - did you forget -v <something>:${BUILD_DIR}?"
  exit 1
fi

# Environment setup.
export USER=bazel
export TEST_TMPDIR=/build/tmp
export BAZEL="bazel"

# Not sandboxing, since non-privileged Docker can't do nested namespaces.
BAZEL_OPTIONS="--package_path %workspace%:/source"
export BAZEL_QUERY_OPTIONS="${BAZEL_OPTIONS}"
export BAZEL_BUILD_OPTIONS="--strategy=Genrule=standalone --spawn_strategy=standalone \
  --verbose_failures ${BAZEL_OPTIONS} --jobs=${NUM_CPUS}"
export BAZEL_TEST_OPTIONS="${BAZEL_BUILD_OPTIONS} --cache_test_results=no --test_output=all"
[[ "${BAZEL_EXPUNGE}" == "1" ]] && "${BAZEL}" clean --expunge

function cleanup() {
  # Remove build artifacts. This doesn't mess with incremental builds as these
  # are just symlinks.
  rm -f "${ENVOY_SRCDIR}"/bazel-*
}
trap cleanup EXIT
