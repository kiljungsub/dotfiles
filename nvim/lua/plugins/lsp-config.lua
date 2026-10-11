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
-- docker_language_server only attaches to yaml.docker-compose, which Neovim
-- doesn't detect on its own
vim.filetype.add({
	filename = {
		["docker-compose.yaml"] = "yaml.docker-compose",
		["docker-compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
	},
	pattern = {
		["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
		["compose%..*%.ya?ml"] = "yaml.docker-compose",
	},
})

vim.lsp.enable({ "lua_ls", "ts_ls", "postgres_lsp", "emmet_language_server", "docker_language_server" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, {})
