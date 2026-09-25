vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvimtools/none-ls-extras.nvim",
	"https://github.com/nvimtools/none-ls.nvim",
})

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		require("none-ls.diagnostics.eslint_d"),
	},
})

vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
