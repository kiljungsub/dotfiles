vim.cmd("language C.UTF-8")

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.opt.scrolloff = 8

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = true

vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,list:full" -- don't insert, show options

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- line numbers
vim.opt.nu = true
vim.opt.rnu = false

-- code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- code
vim.lsp.inlay_hint.enable(true)

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- terminal
vim.api.nvim_command("autocmd TermOpen * startinsert")
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber")
vim.api.nvim_command("autocmd TermEnter * setlocal signcolumn=no")

vim.keymap.set("t", "<esc>", "<C-\\><C-n>")
