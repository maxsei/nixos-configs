PROMPT_DIRTRIM=2

__ps1() {
  local esc=$'\001' end=$'\002'
  local P="${esc}$(tput sgr0)${end}\$" dir="${PWD##*/}" B \
    r="${esc}$(tput setaf 1)${end}" \
    g="${esc}$(tput setaf 0)${end}" \
    h="${esc}$(tput setaf 4)${end}" \
    u="${esc}$(tput setaf 3)${end}" \
    w="${esc}$(tput setaf 5)${end}" \
    b="${esc}$(tput setaf 6)${end}" \
    x="${esc}$(tput sgr0)${end}" \
    p

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

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__ps1"
