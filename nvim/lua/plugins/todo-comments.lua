vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/todo-comments.nvim",
})

local todo = require("todo-comments")

-- Plain Unicode instead of Nerd Font icons
todo.setup({
	keywords = {
		FIX = { icon = "✗" },
		TODO = { icon = "✓" },
		HACK = { icon = "!" },
		WARN = { icon = "⚠" },
		PERF = { icon = "⏱" },
		NOTE = { icon = "•" },
		TEST = { icon = "⏲" },
	},
})

vim.keymap.set("n", "]t", todo.jump_next, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", todo.jump_prev, { desc = "Previous todo comment" })
vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todo comments" })
