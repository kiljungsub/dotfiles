# tmux config

Personal tmux configuration, kept small and mainly tuned for running Neovim
inside tmux.

## Requirements

- tmux >= 1.9 (for `focus-events`)

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
