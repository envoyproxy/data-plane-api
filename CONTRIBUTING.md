# Contributing guide

## API changes

The following high level procedure is used to make Envoy changes that require API changes.

1. Create a PR in this repo for the API/configuration changes. (If it helps to discuss the
   configuration changes in the context of a code change, it is acceptable to point a code
   change at a temporary fork of this repo so it passes tests).
2. Bazel can be used to build/test locally.
   1. Directly on Linux:

      ```
      bazel build //api/...
      bazel test //test/... //tools/...
      ```

   2. Using docker:

      ```
      ./ci/run_envoy_docker.sh './ci/do_ci.sh bazel.test'
      ./ci/run_envoy_docker.sh './ci/do_ci.sh bazel.docs'
      ```
3. All configuration changes should have temporary associated documentation. Fields should be
   hidden from the documentation via the `[#not-implemented-hide:]` comment tag. E.g.,

   ```
   // [#not-implemented-hide:] Some new cool field that I'm going to implement and then
   // come back and doc for real!
   string foo_field = 3;
   ```

   Additionally, [constraints](https://github.com/lyft/protoc-gen-validate/blob/master/README.md)
   should be specified for new fields if applicable. E.g.,

   ```
   string endpoint = 2 [(validate.rules).message.required = true];
   ```

4. Next, the feature should be implemented in Envoy. New versions of data-plane-api are brought
   in via editing [this](https://github.com/envoyproxy/envoy/blob/master/bazel/repository_locations.bzl)
   file.
5. Once (4) is completed, come back here and unhide the field from documentation and complete all
   documentation around the new feature. This may include architecture docs, etc. Optimally, the
   PR for documentation should be reviewed at the same time that the feature PR is reviewed in
   the Envoy repository. See the following section for tips on writing documentation.

## Documentation changes

The Envoy project takes documentation seriously. We view it as one of the reasons the project has
seen rapid adoption. As such, it is required that all features have complete documentation. This is
generally going to be a combination of API documentation as well as architecture/overview
documentation. The documentation can be built locally in the root of this repo via:

```
docs/build.sh
```

Or to use a hermetic docker container:

```
./ci/run_envoy_docker.sh './ci/do_ci.sh bazel.docs'
```

This process builds RST documentation directly from the proto files, merges it with the static RST
files, and then runs [Sphinx](http://www.sphinx-doc.org/en/stable/rest.html) over the entire tree to
produce the final documentation. The following are some general guidelines around documentation.

* Cross link as much as possible. Sphinx is fantastic at this. Use it! See ample examples with the
  existing documentation as a guide.
* Please use a **single space** after a period in documentation so that all generated text is
  consistent.
* Comments can be left inside comments if needed (that's pretty deep, right?) via the `[#comment:]`
  special tag. E.g.,

  ```
  // This is a really cool field!
  // [#comment:TODO(mattklein123): Do something cooler]
  string foo_field = 3;
  ```

* Prefer *italics* for emphasis as `backtick` emphasis is somewhat jarring in our Sphinx theme.
* All documentation is expected to use proper English grammar with proper punctuation. If you are
  not a fluent English speaker please let us know and we will help out.
* Tag messages/enum/files with `[#proto-draft:]` or `[#proto-experimental:]` to
  reflect their (API
  status)[https://www.envoyproxy.io/docs/envoy/latest/configuration/overview/v2_overview#status].
