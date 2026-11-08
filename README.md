# zsh-setbg

An oh-my-zsh plugin to set a per-session terminal background color. Handy for telling multiple sessions apart (several Claude Code sessions, prod vs dev, local vs SSH) at a glance.

It sends an OSC 11 escape sequence, so the color applies to the current tab or window only and resets when you close it. New tabs start with your theme's background; see [Recipes](#recipes) to apply a color automatically.

## Usage

```zsh
setbg            # list presets with color swatches (also: setbg list)
setbg teal       # apply a preset
setbg '#123456'  # any hex color
setbg reset      # back to your theme's background
setbg --help     # show usage
setbg <Tab>      # complete preset names
```

Anything that is not a preset name or a `#rrggbb` color is rejected with an error, so typos don't fail silently.

## Presets

| name   | hex       |
|--------|-----------|
| rose   | `#33141f` |
| copper | `#3d1a06` |
| green  | `#13291a` |
| teal   | `#0f2a2c` |
| blue   | `#121f3a` |
| violet | `#241739` |

Tuned for very dark themes (e.g. GitHub Dark High Contrast): matched brightness, hues spread evenly so they stay distinct.

### Your own presets

Add or override presets in `~/.zshrc` after `source $ZSH/oh-my-zsh.sh` (or after sourcing the plugin file):

```zsh
SETBG_COLORS[prod]='#3a0f14'
```

Entries you define are never overwritten by the built-in presets, and the leading `#` is optional. To define presets before the plugin loads instead, declare the array first: `typeset -gA SETBG_COLORS=( prod '#3a0f14' )`.

Keep the lightness close to your theme's normal background and vary only the hue. Colors that are much lighter or darker than the theme make text harder to read.

## Install

Works on macOS, Linux and Windows (WSL or MSYS2 zsh):

```zsh
git clone https://github.com/mateeyas/zsh-setbg ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/setbg
```

The folder must be named `setbg` to match the plugin file.

Enable it:

```zsh
omz plugin enable setbg
```

This adds `setbg` to the `plugins=(...)` line in `~/.zshrc`, keeps your other plugins, and reloads the shell.

On older oh-my-zsh versions without `omz plugin`, add `setbg` to the end of the existing `plugins=(...)` line in `~/.zshrc` yourself (don't replace the line, or your other plugins stop loading), then run `exec zsh`.

Update later with:

```zsh
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/setbg pull
```

### Without oh-my-zsh

Clone it anywhere and source the plugin file from `~/.zshrc`:

```zsh
source /path/to/zsh-setbg/setbg.plugin.zsh
```

Tab completion is registered if `compinit` has already run; otherwise the command still works, just without completion.

## Recipes

Add these to `~/.zshrc` after the plugin is loaded.

Color every SSH session so remote shells are never mistaken for local ones:

```zsh
[[ -n $SSH_CONNECTION ]] && setbg rose
```

Tint the session for the duration of a command, then restore the theme:

```zsh
withbg() { setbg "$1" && shift && "$@"; local rc=$?; setbg reset; return $rc }

withbg violet claude   # a purple tab while Claude Code runs
```

## Terminal support

| Terminal         | Works | Notes                                                                |
|------------------|-------|----------------------------------------------------------------------|
| Ghostty          | yes   |                                                                      |
| iTerm2           | yes   |                                                                      |
| kitty            | yes   |                                                                      |
| WezTerm          | yes   |                                                                      |
| Alacritty        | yes   |                                                                      |
| Windows Terminal | yes   | `setbg reset` needs 1.22.11141 (April 2025) or newer                 |
| tmux             | yes   | 3.2 or newer; the color applies to the current pane only             |
| Terminal.app     | no    | ignores OSC 11                                                       |

Over SSH, run `setbg` in the remote shell as usual. The drawing is done by your local terminal, so only it needs OSC 11 support.

## License

0BSD: use it however you like, no attribution needed.
