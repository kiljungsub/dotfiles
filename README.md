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

1. Installs Node.js LTS through [nvm](https://github.com/nvm-sh/nvm), unless
   `node` is already on `PATH` (e.g. from the
   `ghcr.io/devcontainers/features/node` feature)
2. Installs [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall)
   when `cargo` is available, unless it's already installed. It downloads
   prebuilt binaries instead of compiling them
3. Installs the latest Neovim release to `~/.local/nvim` (linked from
   `~/.local/bin/nvim`)
4. Installs `tree-sitter-cli` with `cargo-binstall` if available, otherwise
   with `npm`
5. Links `nvim/` to `~/.config/nvim` and `tmux/.tmux.conf` to `~/.tmux.conf`
   (an existing file or directory is moved to `<target>.bak`)

Plugins and treesitter parsers install the first time you start `nvim`, and
Mason packages with `:MasonInstall` (see [nvim/README.md](nvim/README.md#install)).

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

For truecolor and Unicode characters, add this to the project's
`devcontainer.json` (see
[tmux/README.md](tmux/README.md#devcontainer-environment)). Without a UTF-8
`LANG`, tmux shows non-ASCII characters as `_`:

```jsonc
"remoteEnv": {
  "COLORTERM": "truecolor",
  "LANG": "C.UTF-8"
}
```

### Image requirements

The script does not install system packages. The image must provide:

- `curl`, `tar`, `gzip` and `unzip`
- `git`, `make` and a C compiler
- `tmux` >= 3.2 (the script only links `~/.tmux.conf`)
- `ripgrep` (`fd-find` is optional; Telescope uses it for `find_files` when
  present)
- Python 3 with `venv` (for `black` and `isort`). `pip` is not needed, but on
  Debian-based images such as `rust:latest` install `python3-venv`:

  ```dockerfile
  RUN apt-get update \
   && apt-get install -y --no-install-recommends python3-venv \
   && rm -rf /var/lib/apt/lists/*
  ```

`~/.local/bin` must be on `PATH`.
