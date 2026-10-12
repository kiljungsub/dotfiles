vim.pack.add({ "https://github.com/AlexvZyl/nordic.nvim" })

require("nordic").setup({
	-- Visual selection options.
	visual = {
		-- Available styles: 'dark', 'light'.
		theme = "light",
	},
})

vim.cmd.colorscheme("nordic")
