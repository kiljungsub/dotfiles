# dotfiles

Personal configuration files.

## Contents

| Directory | Description                                                        |
| --------- | ------------------------------------------------------------------ |
| `nvim/`   | Neovim config (built-in `vim.pack`), see [nvim/README.md](nvim/README.md) |

## Install

Clone the repository and symlink each config into place:

```sh
git clone git@github.com:mediact-kiljungsub/dotfiles.git ~/Developer/dotfiles
ln -s ~/Developer/dotfiles/nvim ~/.config/nvim
```

If a config already exists at the target, move it out of the way first
(e.g. `mv ~/.config/nvim ~/.config/nvim.bak`).
