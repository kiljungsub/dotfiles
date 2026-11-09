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

local gitsigns = require("gitsigns")

gitsigns.setup()

-- The popup preview paints whole lines with GitSignsAddPreview / DeletePreview
-- at a higher priority than syntax highlighting. They inherit the sign colors,
-- which set fg, so the code shows up all green or red. Keep only the background.
local function preview_highlights()
	for group, base in pairs({ GitSignsDeletePreview = "DiffDelete", GitSignsAddPreview = "DiffAdd" }) do
		vim.api.nvim_set_hl(0, group, { bg = vim.api.nvim_get_hl(0, { name = base, link = false }).bg })
	end
end

preview_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = preview_highlights })

-- ]c / [c are Neovim's own "next / previous change" in diff mode (Diffview,
-- :diffthis), so keep that there and jump between hunks everywhere else.
local function map_hunk_nav(key, direction)
	vim.keymap.set("n", key, function()
		if vim.wo.diff then
			vim.cmd.normal({ key, bang = true })
		else
			gitsigns.nav_hunk(direction)
		end
	end, { desc = direction == "next" and "Next hunk" or "Previous hunk" })
end

map_hunk_nav("]c", "next")
map_hunk_nav("[c", "prev")

-- Both show the deleted lines of the hunk under the cursor; the inline one
-- uses virtual lines and is cleared as soon as the cursor moves
vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk (popup)" })
vim.keymap.set("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk (inline)" })
