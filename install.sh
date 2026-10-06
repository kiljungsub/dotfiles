#!/usr/bin/env bash
# Dotfiles installer, run by devcontainers when the dotfiles option is used.
# Installs Neovim, Node.js (nvm) and tree-sitter-cli, and links the Neovim
# and tmux configs. Plugins and treesitter parsers install on Neovim's first
# start; Mason packages with :MasonInstall.
# fd-find, ripgrep, git, make and a C compiler come from the Dockerfile.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_INSTALL_DIR="$HOME/.local/nvim"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
NVM_VERSION="v0.40.3"
# Keep an NVM_DIR set by the image, e.g. by the devcontainers node feature
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

export PATH="$BIN_DIR:$HOME/.cargo/bin:$PATH"

log() {
  >&2 echo "==> $*"
}

install_neovim() {
  local arch
  case "$(uname -m)" in
    x86_64) arch="x86_64" ;;
    aarch64|arm64) arch="arm64" ;;
    *)
      echo >&2 "Error: unsupported architecture $(uname -m) for neovim install."
      exit 1
      ;;
  esac

  local asset="nvim-linux-${arch}.tar.gz"
  local url="https://github.com/neovim/neovim/releases/latest/download/${asset}"
  local tmp_dir
  tmp_dir="$(mktemp -d)"

  log "Installing Neovim"
  curl -fsSL "$url" -o "$tmp_dir/$asset"

  rm -rf "$NVIM_INSTALL_DIR"
  mkdir -p "$NVIM_INSTALL_DIR"
  tar -xzf "$tmp_dir/$asset" -C "$NVIM_INSTALL_DIR" --strip-components=1
  rm -rf "$tmp_dir"

  mkdir -p "$BIN_DIR"
  ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$BIN_DIR/nvim"

  log "$(nvim --version | head -n1) installed"
}

install_node() {
  if command -v node >/dev/null 2>&1; then
    log "Node.js $(node --version) already installed, skipping nvm"
    return
  fi

  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    log "Installing nvm $NVM_VERSION"
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
  fi

  # nvm.sh is not compatible with `set -u`
  set +u
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh"
  log "Installing Node.js LTS"
  nvm install --lts
  nvm alias default 'lts/*'
  set -u

  log "Node.js $(node --version) installed"
}

install_tree_sitter_cli() {
  if command -v cargo >/dev/null 2>&1; then
    # cargo-binstall downloads a prebuilt binary instead of compiling, and
    # only builds from source if none is available for this platform
    if ! command -v cargo-binstall >/dev/null 2>&1; then
      log "Installing cargo-binstall"
      curl -L --proto '=https' --tlsv1.2 -sSf \
        https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    fi
    log "Installing tree-sitter-cli with cargo-binstall"
    cargo binstall --no-confirm --locked tree-sitter-cli
  else
    log "Installing tree-sitter-cli with npm"
    npm install -g tree-sitter-cli
  fi

  log "$(tree-sitter --version) installed"
}

# link <source in dotfiles> <target>; an existing non-symlink target is
# moved to <target>.bak first
link() {
  local source="$DOTFILES_DIR/$1" target="$2"

  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    log "Backing up existing $target to $target.bak"
    rm -rf "$target.bak"
    mv "$target" "$target.bak"
  fi
  ln -sfn "$source" "$target"

  log "Linked $target -> $source"
}

link_config() {
  link nvim "$CONFIG_DIR/nvim"
  link tmux/.tmux.conf "$HOME/.tmux.conf"
}

main() {
  install_neovim
  install_node
  install_tree_sitter_cli
  link_config
  log "Done"
}

main "$@"
