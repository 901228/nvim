local M = {}

M.setup = function()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        show_header = false,
        severity_sort = true,
        float = {
            source = "always",
            border = "rounded",
            style = "minimal",
            header = "",
            -- prefix = " ",
            -- max_width = 100,
            -- width = 60,
            -- height = 20,
        },
    })

    require('util').setup_diagnostics_icon()
end

return M
