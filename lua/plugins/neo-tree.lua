return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			default_component_configs = {
				name = {
					trailing_slash = true,
				},
				icon = {
					folder_closed = "▸",
					folder_open = "▾",
					folder_empty = " ",
					default = " ",
				},
				git_status = {
					symbols = {
						-- Git 공식 표기 따르기
						added = "A",
						modified = "M",
						deleted = "D",
						renamed = "R",
						-- 추가 상태
						untracked = "?",
						ignored = "!",
						unstaged = "U",
						staged = "S",
						conflict = "C",
					},
				},
			},
			window = {
				position = "current",
			},
		})

		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {})
	end,
}
