vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
})

require("mason").setup({
	PATH = "append",
})

require("mason-lspconfig").setup({
	ensure_installed = {},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("lua_ls", { capabilities = capabilities })
vim.lsp.config("ts_ls", { capabilities = capabilities })
vim.lsp.config("postgres_lsp", {})

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, {})
