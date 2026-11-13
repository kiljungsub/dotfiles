vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

require("lualine").setup({
	options = {
		theme = "nordic",
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_c = {
			{
				"filename",
				-- Absolute path with $HOME shortened to ~
				path = 3,
			},
		},
		lualine_x = {
			"encoding",
			{
				"fileformat",
				symbols = {
					mac = "CR",
					unix = "LF",
					dos = "CRLF",
				},
			},
			"filetype",
		},
	},
})
