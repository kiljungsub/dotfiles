# dotfiles

Personal configuration files.

## Contents

| Directory | Description                                                        |
| --------- | ------------------------------------------------------------------ |
| `nvim/`   | Neovim config (built-in `vim.pack`), see [nvim/README.md](nvim/README.md) |
| `tmux/`   | tmux config, see [tmux/README.md](tmux/README.md)                  |

## Install

Clone the repository and symlink each config into place:

```sh
git clone https://github.com/mediact-kiljungsub/dotfiles.git ~/Developer/dotfiles
ln -s ~/Developer/dotfiles/nvim ~/.config/nvim
ln -s ~/Developer/dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

If a config already exists at the target, move it out of the way first
(e.g. `mv ~/.config/nvim ~/.config/nvim.bak`).

## Devcontainers

`install.sh` is run automatically when this repository is used as the
devcontainer dotfiles repository. It:

1. Installs the latest Neovim release to `~/.local/nvim` (linked from
   `~/.local/bin/nvim`)
2. Installs Node.js LTS through [nvm](https://github.com/nvm-sh/nvm)
3. Installs `tree-sitter-cli` with `cargo` if available, otherwise with `npm`
4. Links `nvim/` to `~/.config/nvim` and `tmux/.tmux.conf` to `~/.tmux.conf`
   (an existing file or directory is moved to `<target>.bak`)
5. Installs plugins, Mason packages and treesitter parsers headless

### Usage

With the [Dev Container CLI](https://github.com/devcontainers/cli), run these
from the project folder to start the container with this repository as the
dotfiles repository, then open tmux in it:

```sh
devcontainer up --dotfiles-repository mediact-kiljungsub/dotfiles
devcontainer exec tmux new-session -A -s main
```

`install.sh` runs once, when the container is created. `new-session -A -s main`
attaches to the `main` session if it already exists, so running the `exec`
command again reconnects to the same session. Detach with `<C-b> d`; the
session keeps running in the container.

### Image requirements

The script does not install system packages. The image must provide:

- `curl`, `tar`, `gzip` and `unzip`
- `git`, `make` and a C compiler
- `tmux` (the script only links `~/.tmux.conf`)
- `ripgrep` (`fd-find` is optional; Telescope uses it for `find_files` when
  present)
- Python 3 with `venv` (for `black` and `isort`). `pip` is not needed, but on
  Debian-based images such as `rust:latest` install `python3-venv`:

  ```dockerfile
  RUN apt-get update \
   && apt-get install -y --no-install-recommends python3-venv \
   && rm -rf /var/lib/apt/lists/*
  ```

`~/.local/bin` must be on `PATH`. Errors inside headless Neovim don't fail the
script, so check the build log or `:Mason` if a tool is missing.
