load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

local_repository(
    name = "bazel_rules_go",
    path = "bazel/go/",
)


load("@bazel_rules_go//:repos.bzl", "add_go_repos")
add_go_repos()
load("@bazel_rules_go//:def.bzl", "go_rules_deps")
go_rules_deps()

load("//bazel/docker:repos.bzl", "docker_repos")
docker_repos()

load("//bazel/docker:def.bzl", "docker_deps")
docker_deps()



load("//:go_third_party.bzl", "go_deps")
# gazelle:repository_macro go_third_party.bzl%go_deps
go_deps()
