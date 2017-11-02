workspace(name = "envoy_api")

load("//bazel:repositories.bzl", "api_dependencies")

api_dependencies()

# TODO(htuch): This can switch back to a point release http_archive at the next
# release (> 3.4.1), we need HEAD proto_library support and
# https://github.com/google/protobuf/pull/3761.
http_archive(
    name = "com_google_protobuf",
    strip_prefix = "protobuf-c4f59dcc5c13debc572154c8f636b8a9361aacde",
    sha256 = "5d4551193416861cb81c3bc0a428f22a6878148c57c31fb6f8f2aa4cf27ff635",
    url = "https://github.com/google/protobuf/archive/c4f59dcc5c13debc572154c8f636b8a9361aacde.tar.gz",
)

# Needed for cc_proto_library, Bazel doesn't support aliases today for repos,
# see https://groups.google.com/forum/#!topic/bazel-discuss/859ybHQZnuI and
# https://github.com/bazelbuild/bazel/issues/3219.
http_archive(
    name = "com_google_protobuf_cc",
    strip_prefix = "protobuf-c4f59dcc5c13debc572154c8f636b8a9361aacde",
    sha256 = "5d4551193416861cb81c3bc0a428f22a6878148c57c31fb6f8f2aa4cf27ff635",
    url = "https://github.com/google/protobuf/archive/c4f59dcc5c13debc572154c8f636b8a9361aacde.tar.gz",
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

git_repository(
    name = "io_bazel_rules_go",
    remote = "https://github.com/bazelbuild/rules_go.git",
    commit = "4374be38e9a75ff5957c3922adb155d32086fe14",
)
load("@io_bazel_rules_go//go:def.bzl", "go_rules_dependencies", "go_register_toolchains")
go_rules_dependencies()
go_register_toolchains()
load("@io_bazel_rules_go//proto:def.bzl", "proto_register_toolchains")
proto_register_toolchains()
