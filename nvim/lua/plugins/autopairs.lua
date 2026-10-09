vim.pack.add({
	"https://github.com/windwp/nvim-autopairs",
})

require("nvim-autopairs").setup({})

-- Add the closing pair when a completion that is a function/method is confirmed
local cmp = require("cmp")
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
