#!/bin/bash

# Script that lists all the steps take by the CI system when doing Envoy builds.
set -e

# We reuse the https://github.com/lyft/envoy/ CI image here to get Bazel.
ENVOY_BUILD_SHA=114e24c6fd05fc026492e9d2ca5608694e5ea59d

# Lint travis file.
#travis lint .travis.yml --skip-completion-check

# Where the Envoy build takes place.
export ENVOY_API_BUILD_DIR=/tmp/envoy-api-docker-build

# Do a build matrix with different types of builds docs, coverage, bazel.release, etc.
docker run -t -i -v "$ENVOY_API_BUILD_DIR":/build -v $TRAVIS_BUILD_DIR:/source \
  lyft/envoy-build:$ENVOY_BUILD_SHA /bin/bash -c "cd /source && ci/do_ci.sh bazel.test"
