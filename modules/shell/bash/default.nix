{ config, lib, pkgs, ... }:
{
  programs.bash.promptInit = builtins.readFile (./prompt.bash);
  programs.bash.shellAliases = {
    l="ls --group-directories-first -lh";
    ll="ls --group-directories-first -alh";
    clip="xclip -selection clipboard";
    pushdtmp="pushd $(mktemp -d)";
    libsearch="ldconfig -p | grep $@";
    funcs="typeset -F";
    mkcd=''{ IFS= read -r d && mkdir "$d" && cd "$_"; } <<<'';
    git-repo=''{
      IFS= read -r d;
      # rd="$(echo "$d" | rev | cut -d "/" -f -2 | rev)";
      # git clone $d "~/Documents/repos/$rd";
      repo_path="$(echo "$d" | perl -nle '$x = $2 if (/(git@|https:\/\/)(.*?)(.git$|$)/); $x =~ s/:/\//; print $x')"
      git clone $d ~/Documents/repos/$repo_path
    } <<<'';
  };
  programs.bash.vteIntegration = true;
  programs.bash.interactiveShellInit = builtins.readFile (./bashrc);
}
