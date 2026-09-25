-- Parsers are updated by the PackChanged hook in config/pack.lua
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

-- Already installed parsers are skipped, so this is cheap on every startup
require("nvim-treesitter").install({
	"bash",
	"c",
	"css",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rust",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		-- Fails when there's no parser for this filetype; keep regex syntax then
		if not pcall(vim.treesitter.start, args.buf) then
			return
		end
		vim.wo[0][0].foldmethod = "expr"
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
