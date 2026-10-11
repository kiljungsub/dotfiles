vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
})

-- Add connections here or from :DBUI. Keep passwords out of the URL; psql reads
-- PGPASSWORD and ~/.pgpass.
-- vim.g.dbs = { local_pg = "postgres://postgres@localhost:5432/mydb" }
vim.g.db_ui_use_nerd_fonts = 0

vim.keymap.set("n", "<leader>D", "<cmd>DBUIToggle<CR>", { desc = "Toggle database UI" })

-- Schema-aware completion next to the LSP (postgres-language-server only
-- attaches in projects that have a postgres-language-server.jsonc). Without a
-- dadbod connection the vim-dadbod-completion source just returns nothing.
-- This replaces the global cmp sources for these buffers, so nvim_lsp and
-- buffer are listed again.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	callback = function()
		require("cmp").setup.buffer({
			sources = {
				{ name = "nvim_lsp" },
				{ name = "vim-dadbod-completion" },
				{ name = "buffer" },
			},
		})
	end,
})
