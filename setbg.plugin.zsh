# setbg: per-session terminal background colors via OSC 11
# Works in terminals that support OSC 11 (Ghostty, iTerm2, kitty, WezTerm,
# Alacritty, Windows Terminal) and inside tmux panes.
# Usage: setbg [list | reset | <name> | <#rrggbb>]

# Defaults only fill in presets that are not already defined, so custom
# entries can be added anywhere in ~/.zshrc.
typeset -gA SETBG_COLORS
() {
  local name hex
  for name hex in \
    rose   '#33141f' \
    copper '#3d1a06' \
    green  '#13291a' \
    teal   '#0f2a2c' \
    blue   '#121f3a' \
    violet '#241739'
  do
    (( $+SETBG_COLORS[$name] )) || SETBG_COLORS[$name]=$hex
  done
}

setbg() {
  case $1 in
    ''|list)
      local name hex
      for name in ${(ko)SETBG_COLORS}; do
        hex=${SETBG_COLORS[$name]#\#}
        printf '\e[48;2;%d;%d;%dm        \e[0m  %-8s #%s\n' \
          $((16#${hex[1,2]})) $((16#${hex[3,4]})) $((16#${hex[5,6]})) $name $hex
      done ;;
    reset) printf '\e]111\a' ;;
    -h|--help)
      print 'usage: setbg [list | reset | <name> | <#rrggbb>]' ;;
    *)
      local color=${SETBG_COLORS[$1]:-$1}
      if [[ ! $color =~ '^#?([0-9a-fA-F]{6})$' ]]; then
        print -u2 "setbg: unknown color '$1' (expected a preset name or #rrggbb)"
        return 1
      fi
      printf '\e]11;#%s\a' "$match[1]" ;;
  esac
}

_setbg() { _values 'color' ${(ko)SETBG_COLORS} list reset }
if (( $+functions[compdef] )); then
  compdef _setbg setbg
fi
