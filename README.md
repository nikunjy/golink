# golink

Bazel hack for linking go generated srcs. Find more detials on this post I wrote [here](https://medium.com/goc0de/a-cute-bazel-proto-hack-for-golang-ides-2a4ef0415a7f?source=friends_link&sk=2ee762dff53812f8068b44f9e0f085f7).

You can use it for copying over golang generated proto files into your source directory.
This is important if you want to make your IDE work because you project needs to be `go build` compliant.

Note that this is a hack and there will be more ideal solutions in the future. unfortunately no solution exists for the problem stated above just yet.

# Installation

Follow these instructions strictly.

## Add this to your `MODULE.bazel`

```bazel
bazel_dep(name = "golink", version = "2.0.0")
bazel_dep(name = "bazel_skylib", version = "1.7.1")
```

## Use Gazelle

You have to use [gazelle](https://github.com/bazelbuild/bazel-gazelle). If you don't know what that means, follow the link and instruction there in.

## Integrate golink

In your root `BUILD.bazel`

```bazel
load("@bazel_gazelle//:def.bzl", "DEFAULT_LANGUAGES", "gazelle_binary")
gazelle_binary(
     name = "gazelle_binary",
     languages = DEFAULT_LANGUAGES + ["@golink//gazelle/go_link:go_default_library"],
     visibility = ["//visibility:public"],
)
```

and change your gazelle target to use the above binary

```bazel
# gazelle:prefix github.com/nikunjy/go
gazelle(
    name = "gazelle",
    gazelle = "//:gazelle_binary",
)
```

Now when you run `bazel run //:gazelle` it will generate a target of `go_proto_link` type for your protos. If you run this target you will copy the generated sources into your repo.

## Example

Here are two commits I did on my sample monorepo:
* [Adding golink dependency](https://github.com/nikunjy/go/commit/515430cb666facb10df81a1df6597cd4cf24e69e)
* [Result of running `bazel run //:gazelle`](https://github.com/nikunjy/go/commit/7423c84db9a584d7429a34600e5a621654ea3cad)
