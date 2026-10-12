# Neovim config

Personal Neovim configuration. Plugins are managed with Neovim's built-in
[`vim.pack`](https://neovim.io/doc/user/pack.html#vim.pack).
Main focus: Rust, Lua, TypeScript/JavaScript and Python.

## Requirements

- Neovim >= 0.12
- `git` and `make` (to build `telescope-fzf-native`)
- A C compiler and `tree-sitter` CLI 0.26.1+ (for treesitter parsers), installed
  with `cargo binstall tree-sitter-cli` (prebuilt, fast),
  `cargo install --locked tree-sitter-cli` or `npm install -g tree-sitter-cli`
  (not the `tree-sitter` npm package, which is only the Node.js bindings)
- `ripgrep` (for `live_grep`, and `find_files` when `fd` is missing)
- Optional: `fd` / `fdfind` (used by `find_files` when available)
- Node.js (for GitHub Copilot and the npm-based Mason packages; run
  `:Copilot setup` once)
- Python 3 with `venv` (for Mason to install `black` and `isort`). `pip` is not
  needed, but on Debian/Ubuntu `python3 -m venv` fails without the
  `python3-venv` package
- `curl` or `wget`, `unzip`, `tar` and `gzip` (for Mason downloads)
- Rust: `rustc` and `rust-analyzer` (e.g. via `rustup component add rust-analyzer`)
- Rust debugging: `/usr/bin/lldb-dap-19`. lldb launches with ASLR left on
  (`settings set target.disable-aslr false` in `preRunCommands`), because
  Docker's default seccomp profile blocks turning it off ("personality set
  failed: Operation not permitted"). lldb-dap-19 ignores `disableASLR = false`
  on its own
- Optional: `psql` (`postgresql-client`), to run queries with vim-dadbod; see
  [Databases](#databases-vim-dadbod). On Debian the package is usually an older
  version; newer ones come from the PostgreSQL apt repository
  (`apt.postgresql.org`)

### Language servers, formatters and linters

These must be on `PATH`:

| Tool                         | Used for                                 |
| ---------------------------- | ---------------------------------------- |
| `lua-language-server`        | Lua LSP (`lua_ls`)                       |
| `typescript-language-server` | TypeScript/JavaScript LSP (`ts_ls`)      |
| `postgres-language-server`   | SQL LSP (`postgres_lsp`); only starts in projects with a `postgres-language-server.jsonc` |
| `emmet-language-server`      | Emmet abbreviations (`emmet_language_server`) |
| `docker-language-server`      | Dockerfile, Compose and Bake LSP (`docker_language_server`) |
| `stylua`                     | Lua formatting                           |
| `prettierd`                  | JS/TS, JSON, CSS, HTML, Markdown, YAML formatting |
| `black`, `isort`             | Python formatting                        |
| `eslint_d`                   | JS/TS linting (needs an ESLint config in the project) |

Install them with Mason:

```
:MasonInstall lua-language-server typescript-language-server postgres-language-server emmet-language-server docker-language-server stylua prettierd black isort eslint_d
```

Check with `:checkhealth null-ls` and `:checkhealth vim.lsp`.

## Install

```sh
git clone https://github.com/kiljungsub/dotfiles.git ~/Developer/dotfiles
ln -s ~/Developer/dotfiles/nvim ~/.config/nvim
nvim
```

On first start `vim.pack` asks to install the plugins and installs them at the
revisions pinned in `nvim-pack-lock.json`. Treesitter parsers are then built
in the background.

Then install the language servers, formatters and linters with
`:MasonInstall` (see above).

In a devcontainer, `install.sh` at the repository root installs Neovim and
creates the link; see the [top-level README](../README.md).

## Layout

```
init.lua              entry point
lua/vim-options.lua   editor options, leader keys
lua/config/pack.lua   build hooks and load order of plugin modules
lua/plugins/          one file per plugin (or group of plugins); each calls
                      vim.pack.add() and then configures its plugins
after/ftplugin/       filetype-specific overrides
nvim-pack-lock.json   plugin revisions (commit this)
```

To add a plugin, add it to a `vim.pack.add()` call (or a new file in
`lua/plugins/` required from `lua/config/pack.lua`) and restart.

## Clipboard

The `+` and `*` registers use OSC 52, so `"+y` copies to the host clipboard
from devcontainers, SSH and tmux without `xclip` or `wl-copy`. The terminal
must support OSC 52; inside tmux, see [tmux/README.md](../tmux/README.md).

Most terminals (e.g. Windows Terminal) don't allow reading the clipboard
through OSC 52, so `"+p` pastes the last yank. To paste from the host, use the
terminal's paste key (e.g. `<C-S-v>` or `<C-v>`).

## Key mappings

Leader is `<Space>`, local leader is `\`.

| Keys          | Mode   | Action                            |
| ------------- | ------ | --------------------------------- |
| `<C-p>`       | n      | Find files (Telescope)            |
| `<leader>fg`  | n      | Live grep (Telescope)             |
| `<leader>ft`  | n      | Find TODO/FIXME/... comments (Telescope) |
| `]t` / `[t`   | n      | Next / previous TODO comment (replaces Neovim's default `:tnext` / `:tprevious`) |
| `<leader>e`   | n      | Toggle file tree (Neo-tree)       |
| `K`           | n      | LSP hover (rustaceanvim actions in Rust) |
| `gd`          | n      | Go to definition                  |
| `<leader>a`   | n, v   | Code action                       |
| `<leader>gf`  | n      | Format buffer                     |
| `<leader>D`   | n      | Toggle database UI (dadbod-ui)    |
| `<leader>b`   | n      | Toggle breakpoint                 |
| `<F5>`        | n      | Start / continue debugging        |
| `<leader>du`  | n      | Toggle debugger UI (dap-ui)       |
| `<leader>dq`  | n      | Stop debugging                    |
| `<Esc>`       | t      | Leave terminal mode               |

### Git

| Keys         | Action                                     |
| ------------ | ------------------------------------------ |
| `<leader>gd` | Toggle Diffview (uncommitted changes)      |
| `<leader>gh` | History of the current file (Diffview)     |
| `<leader>gH` | Repository history (Diffview)              |
| `q`          | Close Diffview (inside a Diffview window)  |

Gitsigns shows added/changed/deleted lines in the sign column.

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

### Databases (vim-dadbod)

vim-dadbod runs queries through the database's CLI, so `psql`
(`postgresql-client`) must be installed. `<leader>D` toggles the DB UI
(vim-dadbod-ui).

**Connections.** Don't commit them: URLs in `vim.g.dbs` end up in this
repository. Instead:

- Export `DBUI_URL` (and optionally `DBUI_NAME`) before starting Neovim, e.g.
  `export DBUI_URL="postgres://postgres@localhost:5432/mydb"`. `DATABASE_URL`
  is used when `DBUI_URL` is not set. Without `DBUI_NAME` the connection is
  named after the last path segment of the URL. To load a plain `KEY=value`
  `.env` file, which most tools read, run `set -a; source .env; set +a` in the
  shell first so the variables are exported to Neovim.
- Or add one with `:DBUIAddConnection` (saved outside this repository, in
  `g:db_ui_save_location`).

**Passwords.** Leave them out of the URL. `psql` reads `PGPASSWORD` and
`~/.pgpass` (`host:port:database:user:password`, `chmod 600`). To fetch a
secret at connect time, `vim.g.dbs` accepts a function for `url`, e.g.
`url = function() return vim.fn.system("get-url"):gsub("\n", "") end`. For
Azure PostgreSQL with Microsoft Entra, the access token from
`az account get-access-token` goes into `PGPASSWORD`.

**Running a `.sql` file** (without the UI):

| Command                  | Action                                      |
| ------------------------ | ------------------------------------------- |
| `:DB b:db = <url>`       | Set the database for this buffer            |
| `:%DB`                   | Run the whole buffer on `b:db`/`$DATABASE_URL` |
| `:'<,'>DB`               | Run the visual selection                    |
| `:DB <url> < file.sql`   | Run a file on the given database            |

Without a URL, the first of `w:db`, `t:db`, `b:db`, `$DATABASE_URL` and `g:db`
is used. In the result window `R` reruns, `r` reruns interactively and `gq`
closes it.

**With the UI.** `:DBUIFindBuffer` assigns the current buffer to a connection;
`<leader>S` then runs the buffer (normal mode) or the selection (visual mode).
`g:db_ui_execute_on_save` defaults to 1 and runs DBUI-managed buffers on every
save, so queries that change data run too. Set `vim.g.db_ui_execute_on_save = 0`
to turn it off.

Completion in SQL buffers combines the LSP, vim-dadbod-completion (tables and
columns of the connected database) and words from the buffer.
`postgres-language-server` only attaches in projects with a
`postgres-language-server.jsonc`.

## Updating plugins

- `:lua vim.pack.update()` fetches updates and opens a review buffer.
  `:w` applies them, `:q` discards them. Commit `nvim-pack-lock.json` afterwards.
- `:lua vim.pack.update(nil, { target = "lockfile" })` puts plugins back at
  the revisions in `nvim-pack-lock.json` (e.g. after `git pull` or to undo an update).
- Treesitter parsers are updated automatically when nvim-treesitter updates;
  `:TSUpdate` does it manually.
- To remove a plugin, delete it from the config, restart, then
  `:lua vim.pack.del({ "plugin-name" })`.
