PROMPT_DIRTRIM=2

__ps1() {
  local P='\\$\[$(tput sgr0)\]' dir="${PWD##*/}" B \
    r='\[\e[31m\]' g='\[\e[30m\]' h='\[\e[34m\]' \
    u='\[\e[33m\]' p              w='\[\e[35m\]' \
    b='\[\e[36m\]' x='\[\e[0m\]'

  # Root
  [[ $EUID == 0 ]] && u=$r

  p=$u

  # Shell depth.
	local depth
	if [ $SHLVL -gt 1 ]; then
		depth="$(seq 2 $SHLVL | xargs -L 1 printf ">%.0s") "
	fi

  # Git branch
  B=$(git branch --show-current 2>/dev/null)
  [[ $B == master || $B == main ]] && b="$r"
  [[ -n "$B" ]] && B="$g($b$B$g)"

  PS1="$depth$u\u$g@$h\h$g:$w\w$B$p\n$P$x "
}

PROMPT_COMMAND="__ps1"
