# Neovim config

Personal Neovim configuration, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).
Main focus: Rust, Lua, TypeScript/JavaScript and Python.

## Requirements

- Neovim >= 0.12
- `git` and `make` (to build `telescope-fzf-native`)
- A C compiler and `tree-sitter` CLI (for treesitter parsers)
- `ripgrep` (for `live_grep`)
- Formatters/linters used by none-ls: `stylua`, `prettierd`, `black`, `isort`, `eslint_d`
- Rust debugging: `rustc` and `/usr/bin/lldb-dap-19`
- GitHub Copilot: run `:Copilot setup` once

Language servers can be installed with `:Mason`.

## Install

```sh
git clone <repo-url> ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself on first start and installs the plugins at the
versions pinned in `lazy-lock.json`.

## Layout

```
init.lua              entry point
lua/vim-options.lua   editor options, leader keys
lua/config/lazy.lua   lazy.nvim bootstrap
lua/plugins/          one file per plugin (or group of plugins)
after/ftplugin/       filetype-specific overrides
```

## Key mappings

Leader is `<Space>`, local leader is `\`.

| Keys          | Mode   | Action                            |
| ------------- | ------ | --------------------------------- |
| `<C-p>`       | n      | Find files (Telescope)            |
| `<leader>fg`  | n      | Live grep (Telescope)             |
| `<leader>e`   | n      | Toggle file tree (Neo-tree)       |
| `K`           | n      | LSP hover (rustaceanvim actions in Rust) |
| `gd`          | n      | Go to definition                  |
| `<leader>a`   | n, v   | Code action                       |
| `<leader>gf`  | n      | Format buffer                     |
| `<leader>b`   | n      | Toggle breakpoint                 |
| `<F5>`        | n      | Start / continue debugging        |
| `<Esc>`       | t      | Leave terminal mode               |

### Completion (insert mode)

| Keys        | Action                 |
| ----------- | ---------------------- |
| `<C-Space>` | Open completion menu   |
| `<CR>`      | Confirm selection      |
| `<C-e>`     | Abort                  |
| `<C-b>` / `<C-f>` | Scroll docs      |

### Crates (in `Cargo.toml`)

| Keys         | Action                           |
| ------------ | -------------------------------- |
| `<leader>ct` | Toggle crates info               |
| `<leader>cr` | Reload                           |
| `<leader>cv` | Show versions popup              |
| `<leader>cf` | Show features popup              |
| `<leader>cd` | Show dependencies popup          |
| `<leader>cu` | Update crate(s) (n / v)          |
| `<leader>ca` | Update all crates                |
| `<leader>cU` | Upgrade crate(s) (n / v)         |
| `<leader>cA` | Upgrade all crates               |
| `<leader>cx` | Expand plain crate to inline table |
| `<leader>cX` | Extract crate into table         |
| `<leader>cH` / `cR` / `cD` / `cC` / `cL` | Open homepage / repository / docs / crates.io / lib.rs |

### CSV (after `:CsvViewEnable`)

| Keys                | Action                       |
| ------------------- | ---------------------------- |
| `<Tab>` / `<S-Tab>` | Next / previous field        |
| `<Enter>` / `<S-Enter>` | Next / previous row      |
| `if` / `af`         | Inner / outer field text object |

## Updating plugins

- `:Lazy update` updates plugins and rewrites `lazy-lock.json`; commit the lockfile afterwards.
- `:Lazy restore` reverts plugins to the versions in `lazy-lock.json`.
- `:TSUpdate` updates treesitter parsers.
