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
	-- stylua already formats through none-ls
	automatic_enable = { exclude = { "stylua" } },
})

vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

-- rust-analyzer is started by rustaceanvim, don't enable it here
vim.lsp.enable({ "lua_ls", "ts_ls", "postgres_lsp" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, {})
