load("@bazel_skylib//lib:shell.bzl", "shell")
load("//:golink.bzl", "gen_copy_files_script")

def go_proto_link_impl(ctx, **kwargs):
    descriptors = ctx.attr.proto_library[ProtoInfo].transitive_descriptor_sets.to_list()
    return gen_copy_files_script(ctx, ctx.attr.dep[OutputGroupInfo].go_generated_srcs.to_list(), descriptors)

_go_proto_link = rule(
    implementation = go_proto_link_impl,
    executable = True,
    attrs = {
        "dir": attr.string(),
        "dep": attr.label(),
        "proto_library": attr.label(),
        "descriptor_name": attr.string(),
        "_template": attr.label(
            default = "//:copy_into_workspace.sh",
            allow_single_file = True,
        ),
        # It is not used, just used for versioning since this is experimental
        "version": attr.string(),
    },
)

def go_proto_link(name, **kwargs):
    if not "dir" in kwargs:
        dir = native.package_name()
        kwargs["dir"] = dir

    _go_proto_link(name = name, **kwargs)
