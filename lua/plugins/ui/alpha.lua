return {
    -- ascii arts
    {
        'MaximilianLloyd/ascii.nvim',
        dependencies = 'MunifTanjim/nui.nvim',
    },

    -- dashboard
    {
        'goolord/alpha-nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'MaximilianLloyd/ascii.nvim',
        },
        lazy = false,
        opts = function()

            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = require('ascii').art.text.neovim.sharp

            if vim.fn.has "win32" ~= 1 then
                dashboard.section.terminal.command = "cat | lolcat --seed=24 "
                .. os.getenv("HOME")
                .. "/.config/nvim/static/neovim.cat"
            end

            -- Set menu
            dashboard.section.buttons.val = {
                -- dashboard.button("l", "   Load session", "<cmd>lua require('persisted').load()<CR>"),
                dashboard.button("e", "  > New file" , "<cmd>ene<CR>"),
                dashboard.button("r", "  > Recent file"   , "<cmd>Telescope oldfiles<CR>"),
                dashboard.button("f", "󰈞  > Find file", "<cmd>Telescope find_files hidden=true path_display=smart<CR>"),
                dashboard.button("g", "  > Search file", "<cmd>Telescope live_grep path_display=smart<CR>"),
                dashboard.button("u", "  > Update plugins"   , "<cmd>PackerSync<CR>"),
                dashboard.button("s", "  > Settings" , "<cmd>e $MYVIMRC | :cd %:p:h | Neotree<CR>"),
                dashboard.button("q", "󰈆  > Quit NVIM", "<cmd>qa!<CR>"),
            }

            -- Footer
            local function footer()
                -- local total_plugins = require('packer').stats().count
                local v = vim.version()
                local datetime = os.date " %Y-%m-%d   %H:%M:%S"
                local platform = require('util').os.is_win() and "" or ""
                return string.format("%s v%d.%d.%d  %s", ' Neovim', v.major, v.minor, v.patch, datetime)
            end

            dashboard.section.footer.val = footer()
            dashboard.section.footer.opts.hl = "AlphaFooter"

            -- Layout
            dashboard.config.layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                -- dashboard.section.terminal,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 1 },
                dashboard.section.footer,
            }
            dashboard.config.opts.noautocmd = false

            return dashboard
        end,
        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    once = true,
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            -- Disable folding on alpha buffer
            vim.cmd([[
                autocmd FileType alpha setlocal nofoldenable
            ]])

            require("alpha").setup(dashboard.opts)

            -- vim.api.nvim_create_autocmd("User", {
            --     once = true,
            --     pattern = "LazyVimStarted",
            --     callback = function()
            --         local stats = require("lazy").stats()
            --         local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            --         dashboard.section.footer.val = "⚡ Neovim loaded "
            --         .. stats.loaded
            --         .. "/"
            --         .. stats.count
            --         .. " plugins in "
            --         .. ms
            --         .. "ms"
            --         pcall(vim.cmd.AlphaRedraw)
            --     end,
            -- })
        end,
    }
}
