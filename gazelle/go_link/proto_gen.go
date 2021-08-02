package go_link

import (
	"flag"

	"github.com/bazelbuild/bazel-gazelle/config"
	"github.com/bazelbuild/bazel-gazelle/label"
	"github.com/bazelbuild/bazel-gazelle/language"
	"github.com/bazelbuild/bazel-gazelle/repo"
	"github.com/bazelbuild/bazel-gazelle/resolve"
	"github.com/bazelbuild/bazel-gazelle/rule"
)

type xlang struct{}

func NewLanguage() language.Language {
	return &xlang{}
}

func (x *xlang) Name() string {
	return "go_proto_link"
}

func (x *xlang) Kinds() map[string]rule.KindInfo {
	return map[string]rule.KindInfo{
		"go_proto_link": {},
	}
}

func (x *xlang) Loads() []rule.LoadInfo {
	return []rule.LoadInfo{
		{
			Name:    "@golink//proto:proto.bzl",
			Symbols: []string{"go_proto_link", "proto_library_descriptor"},
		},
	}
}

func (x *xlang) RegisterFlags(fs *flag.FlagSet, cmd string, c *config.Config) {
}

func (x *xlang) CheckFlags(fs *flag.FlagSet, c *config.Config) error {
	return nil
}

func (x *xlang) KnownDirectives() []string {
	return nil
}

func (x *xlang) Configure(c *config.Config, rel string, f *rule.File) {
}

func (x *xlang) GenerateRules(args language.GenerateArgs) language.GenerateResult {
	rules := make([]*rule.Rule, 0)
	imports := make([]interface{}, 0)

	for _, r := range args.OtherGen {
		if r.Kind() == "go_proto_library" {
			depName := r.Name()
			r := rule.NewRule("go_proto_link", r.Name()+"_link")
			r.SetAttr("dep", ":"+depName)
			r.SetAttr("version", "v1")
			rules = append(rules, r)
			imports = append(imports, nil)
		} else if r.Kind() == "proto_library" {
			depName := r.Name()
			r := rule.NewRule("proto_library_descriptor", r.Name()+"_descriptor")
			r.SetAttr("dep", ":"+depName)
			r.SetAttr("version", "v1")
			rules = append(rules, r)
			imports = append(imports, nil)
		}
	}

	return language.GenerateResult{
		Gen:     rules,
		Imports: imports,
	}
}

func (x *xlang) Fix(c *config.Config, f *rule.File) {
	// Do any migrations here
}

func (x *xlang) Imports(c *config.Config, r *rule.Rule, f *rule.File) []resolve.ImportSpec {
	return nil
}

func (x *xlang) Embeds(r *rule.Rule, from label.Label) []label.Label {
	return nil
}

func (x *xlang) Resolve(c *config.Config, ix *resolve.RuleIndex, rc *repo.RemoteCache, r *rule.Rule, imports interface{}, from label.Label) {
}
