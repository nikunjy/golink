load("@bazel_skylib//lib:shell.bzl", "shell")
def go_proto_link_impl(ctx, **kwargs):
    print("Copying generated files for proto library %s" % ctx.attr.dep)
    generated = ctx.attr.dep[OutputGroupInfo].go_generated_srcs.to_list()
    content = ""
    for f in generated:
       line = "cp -f %s %s/;\n" % (f.path, ctx.attr.dir)
       content += line
    substitutions = {
        "@@CONTENT@@": shell.quote(content),
    }
    out = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = out,
        substitutions = substitutions,
        is_executable = True,
    )
    runfiles = ctx.runfiles(files = [generated[0]])
    return [
        DefaultInfo(
            files = depset([out]),
            runfiles = runfiles,
            executable = out,
        ),
    ]

_go_proto_link = rule(
    implementation = go_proto_link_impl,
    executable = True,
    attrs = {
        "dir": attr.string(),
        "dep": attr.label(),
        "_template": attr.label(
            default = ":copy_into_workspace.sh",
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