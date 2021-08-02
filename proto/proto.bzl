load("@bazel_skylib//lib:shell.bzl", "shell")
load("//:golink.bzl", "gen_copy_files_script", "gen_copy_descriptor_files_script")

def go_proto_link_impl(ctx, **kwargs):
    return gen_copy_files_script(ctx, ctx.attr.dep[OutputGroupInfo].go_generated_srcs.to_list())


def proto_library_descriptor_impl(ctx, **kwargs):
    descriptors = ctx.attr.dep[ProtoInfo].transitive_descriptor_sets.to_list()
    return gen_copy_descriptor_files_script(ctx, descriptors)

_go_proto_link = rule(
    implementation = go_proto_link_impl,
    executable = True,
    attrs = {
        "dir": attr.string(),
        "dep": attr.label(),
        "_template": attr.label(
            default = "//:copy_into_workspace.sh",
            allow_single_file = True,
        ),
        # It is not used, just used for versioning since this is experimental
        "version": attr.string(),
    },
)

_proto_library_descriptor = rule(
    implementation = proto_library_descriptor_impl,
    executable = True,
    attrs = {
        "dir": attr.string(),
        "dep": attr.label(),
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


def proto_library_descriptor(name, **kwargs):
    if not "dir" in kwargs:
        dir = native.package_name()
        kwargs["dir"] = dir

    _proto_library_descriptor(name = name, **kwargs)
