# tmux config

Personal tmux configuration, kept small and mainly tuned for running Neovim
inside tmux.

## Requirements

- tmux >= 3.2 (for `terminal-features`)
- The `tmux-256color` terminfo entry (in `ncurses-base` on Debian/Ubuntu,
  `ncurses-term` on older releases)
- A terminal emulator with truecolor and OSC 52 support (Windows Terminal,
  iTerm2, WezTerm, kitty, Alacritty, ...). iTerm2 needs "Applications in
  terminal may access clipboard" enabled

## Install

```sh
git clone https://github.com/mediact-kiljungsub/dotfiles.git ~/Developer/dotfiles
ln -s ~/Developer/dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

In a devcontainer, `install.sh` at the repository root creates the link; see
the [top-level README](../README.md).

Reload the config in a running tmux server with:

```sh
tmux source-file ~/.tmux.conf
```

## Settings

| Setting             | Why                                                        |
| ------------------- | ---------------------------------------------------------- |
| `focus-events on`   | Passes focus events to programs in panes, so Neovim's `FocusGained` autocmd runs `:checktime` and reloads files changed outside Neovim |
| `default-terminal "tmux-256color"` | Sets `TERM` inside tmux to a terminfo entry that matches tmux's features |
| `terminal-features ",*:RGB"` | Tells tmux the outer terminal supports 24-bit colour, so truecolor output (e.g. Neovim with `termguicolors`) isn't reduced to 256 colours |
| `set-clipboard on`  | Accepts OSC 52 from programs in panes (e.g. Neovim's `"+y`), stores it as a tmux buffer and forwards it to the outer terminal |
| `terminal-features ",*:clipboard"` | Tells tmux the outer terminal accepts OSC 52, so copies reach the host clipboard |

`allow-passthrough` is left off: tmux handles OSC 52 itself, and passthrough
would let any program in a pane send raw escape sequences to the outer
terminal.

To check OSC 52, run this inside tmux and paste in another application; it
should paste `hello`:

```sh
printf '\033]52;c;%s\a' "$(printf hello | base64)"
```

## Truecolor in devcontainers

`devcontainer exec` doesn't pass the host's `COLORTERM` into the container, so
programs that check it (including Neovim started outside tmux) fall back to
256 colours. Set it in `devcontainer.json`:

```jsonc
{
  "remoteEnv": {
    "COLORTERM": "truecolor"
  }
}
```

To check, run this inside tmux; it should print a smooth gradient:

```sh
awk 'BEGIN { for (i = 0; i < 256; i++) printf "\033[48;2;%d;0;%dm \033[0m", i, 255 - i; print "" }'
```
