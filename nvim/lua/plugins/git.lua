vim.pack.add({
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
})

require("diffview").setup({
	use_icons = false,
	signs = {
		fold_closed = "▸",
		fold_open = "▾",
		done = "✓",
	},
	-- Keep your existing use_icons, icons, and signs settings here
	keymaps = {
		view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
		file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
		file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
	},
})

vim.keymap.set("n", "<leader>gd", function()
	if require("diffview.lib").get_current_view() then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen")
	end
end, { desc = "Toggle Diffview" })

vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Repository history" })

require("gitsigns").setup()
