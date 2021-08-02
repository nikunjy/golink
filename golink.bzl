load("@bazel_skylib//lib:shell.bzl", "shell")

def paths(files):
  return [f.path for f in files]
  
def gen_copy_files_script(ctx, files):
    content=""
    for f in files:
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
    runfiles = ctx.runfiles(files = files)
    return [
        DefaultInfo(
            files = depset([out]),
            runfiles = runfiles,
            executable = out,
        ),
    ]
 
def gen_copy_descriptor_files_script(ctx, descriptors):
    content='cat %s > %s/$1;' % (' '.join(paths(descriptors)), ctx.attr.dir)
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
    runfiles = ctx.runfiles(files = descriptors)
    return [
        DefaultInfo(
            files = depset([out]),
            runfiles = runfiles,
            executable = out,
        ),
    ]

def golink_impl(ctx, **kwargs):
    return gen_copy_files_script(ctx, ctx.files.dep)


_golink = rule(
    implementation = golink_impl,
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

def golink(name, **kwargs):
    if not "dir" in kwargs:
        dir = native.package_name()
        kwargs["dir"] = dir

    _golink(name = name, **kwargs)
