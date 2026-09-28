#!/usr/bin/env bash
# Dotfiles installer, run by devcontainers when the dotfiles option is used.
# Installs Neovim, Node.js (nvm) and tree-sitter-cli, links the Neovim
# config and installs plugins, Mason tools and treesitter parsers headless.
# fd-find, ripgrep, git, make and a C compiler come from the Dockerfile.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_INSTALL_DIR="$HOME/.local/nvim"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
NVM_VERSION="v0.40.3"
export NVM_DIR="$HOME/.nvm"

MASON_PACKAGES=(
  lua-language-server
  typescript-language-server
  postgres-language-server
  stylua
  prettierd
  black
  isort
  eslint_d
)

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
    log "Installing tree-sitter-cli with cargo"
    cargo install --locked tree-sitter-cli
  else
    log "Installing tree-sitter-cli with npm"
    npm install -g tree-sitter-cli
  fi

  log "$(tree-sitter --version) installed"
}

link_config() {
  local target="$CONFIG_DIR/nvim"

  mkdir -p "$CONFIG_DIR"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    log "Backing up existing $target to $target.bak"
    rm -rf "$target.bak"
    mv "$target" "$target.bak"
  fi
  ln -sfn "$DOTFILES_DIR/nvim" "$target"

  log "Linked $target -> $DOTFILES_DIR/nvim"
}

install_plugins() {
  log "Installing Neovim plugins"
  # vim.pack.add() asks before installing; skip the prompt when headless.
  # Plugins are installed at the revisions in nvim-pack-lock.json.
  nvim --headless \
    --cmd "lua local add = vim.pack.add; vim.pack.add = function(specs, opts) return add(specs, vim.tbl_extend('force', opts or {}, { confirm = false })) end" \
    +qa
}

install_mason_packages() {
  log "Installing Mason packages"
  # :MasonInstall blocks until done when running headless
  nvim --headless -c "MasonInstall ${MASON_PACKAGES[*]}" -c qa
}

install_parsers() {
  log "Installing treesitter parsers"
  nvim --headless -c "lua require('plugins.treesitter').install:wait(30 * 60 * 1000)" -c qa
}

main() {
  install_neovim
  install_node
  install_tree_sitter_cli
  link_config
  install_plugins
  install_mason_packages
  install_parsers
  log "Done"
}

main "$@"
