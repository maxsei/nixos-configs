{ tree-sitter, fetchFromGitHub }: {
  templ = tree-sitter.buildGrammar {
    language = "templ";
    version = "0.0.0+rev=671e9a9";
    src = fetchFromGitHub {
      owner = "vrischmann";
      repo = "tree-sitter-templ";
      rev = "671e9a957acd40088919ca17b30f4a39870784d4";
      hash = "sha256-ugBu/05WLmCL1D5bzzaLND/nIQIWXXSurouBewOte8A=";
    };
    meta.homepage = "https://github.com/vrischmann/tree-sitter-templ";
  };
}
