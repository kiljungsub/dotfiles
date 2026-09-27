-- Build hooks. Must be registered before the first vim.pack.add() so they
-- also run when plugins are installed from nvim-pack-lock.json.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end

		if name == "telescope-fzf-native.nvim" then
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		elseif name == "nvim-treesitter" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			require("nvim-treesitter").update()
		end
	end,
})

-- Each module calls vim.pack.add() for its plugins and then configures them.
-- Order matters: a module can only use plugins added before it.
require("plugins.colorscheme")
require("plugins.completions")
require("plugins.lsp-config")
require("plugins.none-ls")
require("plugins.telescope")
require("plugins.neo-tree")
require("plugins.lualine")
require("plugins.treesitter")
require("plugins.rust")
require("plugins.csv")
require("plugins.debugging")
require("plugins.git")
