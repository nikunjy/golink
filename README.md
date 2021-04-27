# golink

Bazel hack for linking go generated srcs. Find more detials on this post I wrote [here](https://medium.com/goc0de/a-cute-bazel-proto-hack-for-golang-ides-2a4ef0415a7f?source=friends_link&sk=2ee762dff53812f8068b44f9e0f085f7).

You can use it for copying over golang generated proto files into your source directory.
This is important if you want to make your IDE work because you project needs to be `go build` compliant.

Note that this is a hack and there will be more ideal solutions in the future. unfortunately no solution exists for the problem stated above just yet.

# Installation

Follow these instructions strictly.

## Add this to your `WORKSPACE`

```bazel
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

http_archive(
    name = "golink",
    urls = ["https://github.com/nikunjy/golink/archive/v1.1.0.tar.gz"],
    sha256 = "c505a82b7180d4315bbaf05848e9b7d2683e80f1b16159af51a0ecae6fb2d54d",
    strip_prefix = "golink-1.1.0",
)
```

## Use Gazelle

You have to use [gazelle](https://github.com/bazelbuild/bazel-gazelle). If you don't know what that means follow the link and instruction there in.

*(only if you don't use gazelle)*, you will probably add two things in `WORKSPACE`

Something like this, check me on version number

```bazel
http_archive(
    name = "bazel_gazelle",
    urls = [
        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/v0.20.0/bazel-gazelle-v0.20.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.20.0/bazel-gazelle-v0.20.0.tar.gz",
    ],
    sha256 = "d8c45ee70ec39a57e7a05e5027c32b1576cc7f16d9dd37135b0eddde45cf1b10",
)`
```
 
In your `BUILD` file you will add something like

```bazel
load("@bazel_gazelle//:def.bzl", "gazelle")

# gazelle:prefix github.com/example/project
gazelle(name = "gazelle")
```

This will generate `BUILD.bazel` files for your golang and proto stuff when you run `bazel run //:gazelle` !!!

## Integrate golink

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
