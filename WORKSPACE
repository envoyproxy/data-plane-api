workspace(name = "envoy_api")

load("//bazel:repositories.bzl", "api_dependencies")

api_dependencies()

# TODO(htuch): This can switch back to an http_archive at the next release (>
# 3.4.1), we need HEAD proto_library support and
# https://github.com/google/protobuf/pull/3761.
git_repository(
    name = "com_google_protobuf",
    commit = "c4f59dcc5c13debc572154c8f636b8a9361aacde",
    remote = "https://github.com/google/protobuf.git",
)

# Needed for cc_proto_library, Bazel doesn't support aliases today for repos,
# see https://groups.google.com/forum/#!topic/bazel-discuss/859ybHQZnuI and
# https://github.com/bazelbuild/bazel/issues/3219.
git_repository(
    name = "com_google_protobuf_cc",
    commit = "c4f59dcc5c13debc572154c8f636b8a9361aacde",
    remote = "https://github.com/google/protobuf.git",
)

bind(
    name = "six",
    actual = "@six_archive//:six",
)

new_http_archive(
    name = "six_archive",
    build_file = "@com_google_protobuf//:six.BUILD",
    sha256 = "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a",
    url = "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz#md5=34eed507548117b2ab523ab14b2f8b55",
)

