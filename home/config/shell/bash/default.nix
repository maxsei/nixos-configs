{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      l = "ls --group-directories-first -lh";
      ll = "ls --group-directories-first -alh";
      clip = "wl-copy";
      pushdtmp = "pushd $(mktemp -d)";
      libsearch = "ldconfig -p | grep $@";
      funcs = "typeset -F";
      mkcd = ''{ IFS= read -r d && mkdir "$d" && cd "$_"; } <<<'';
      git-repo = ''
        {
              IFS= read -r d;
              repo_path="$(echo "$d" | perl -nle '$x = $2 if (/(git@|https:\/\/)(.*?)(.git$|$)/); $x =~ s/:/\//; print $x')"
              git clone $d ~/Documents/repos/$repo_path
            } <<<'';
      devlog = ''
        $EDITOR "$HOME/Documents/devlog/$(date +%Y-%m-%d).md"
      '';
    };
    initExtra = (builtins.readFile ./bashrc) + (builtins.readFile ./prompt.bash);
  };
}
