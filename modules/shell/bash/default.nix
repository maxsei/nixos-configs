{ config, lib, pkgs, ... }:
{
  programs.bash.promptInit = builtins.readFile (./prompt.bash);
  programs.bash.shellAliases = {
    l="ls --group-directories-first -lh";
    ll="ls --group-directories-first -alh";
    clip="xclip -selection clipboard";
    pushdtmp="pushd $(mktemp -d)";
    libsearch="ldconfig -p | grep $@";
  };
  programs.bash.vteIntegration = true;
  programs.bash.interactiveShellInit = builtins.readFile (./bashrc);
}
