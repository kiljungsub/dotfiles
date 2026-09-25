local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
    "n",
    "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
    function()
        -- :RustLsp only exists once rust-analyzer has attached
        if vim.fn.exists(":RustLsp") == 2 then
            vim.cmd.RustLsp({ "hover", "actions" })
        else
            vim.lsp.buf.hover()
        end
    end,
    { silent = true, buffer = bufnr }
)
