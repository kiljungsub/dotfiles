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

-- code folding (treesitter foldexpr is set per buffer in plugins/treesitter.lua)
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

-- clipboard: copy with OSC 52 so "+y reaches the host clipboard from
-- containers, SSH and tmux. Many terminals (e.g. Windows Terminal) don't
-- allow reading the clipboard with OSC 52, so "+p pastes the last yank
-- instead; paste from the host with the terminal's paste key.
local osc52 = require("vim.ui.clipboard.osc52")
local function paste()
	return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end
vim.g.clipboard = {
	name = "OSC 52",
	copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
	paste = { ["+"] = paste, ["*"] = paste },
}

-- tmux
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})
