local common = require('plugins.lsp.common')

return {
    -- Automatically add closing tags for HTML and JSX
    {
        'windwp/nvim-ts-autotag',
        event = 'LazyFile',
        opts = {},
    },

    -- Json
    {
        'b0o/schemastore.nvim',
        ft = { 'json', 'yaml' },
        opts = {},
        config = function() end,
    },

    -- Rust
    {
        'mrcjkb/rustaceanvim',
        bufread = true,
        version = '^5',
        lazy = false,
    },

    -- lua
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        dependencies = {
            { 'Bilal2453/luvit-meta', lazy = true },
            { 'justinsgithub/wezterm-types', lazy = true },
            { 'LelouchHe/xmake-luals-addon', lazy = true },
        },
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
                { path = 'wezterm-types', mods = { 'wezterm' } },
                { path = 'xmake-luala-addon/library', files = { 'xmake.lua' } },
            },
            enabled = function()
                return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
            end,
            integration = {
                lspconfig = true,
                cmp = true,
                coq = false,
            },
        },
    },

    -- lspconfig for langs
    {
        'neovim/nvim-lspconfig',
        opts = {
            -- lsp server settings
            servers = {
                -- <lsp server> = {
                --     mason = false, -- set to false if you don't want this server to be installed with mason
                --     keys = {}, -- add additional keymaps for specific lsp server
                -- },
                -- <lsp server> = true,
                rust_analyzer = true,
                clangd = true,
                cmake = true,
                dockerls = true,
                lemminx = true,
                pyright = true,
                cssls = { single_file_support = true },
                vala_ls = { single_file_support = true },
                jsonls = {
                    settings = {
                        json = {
                            schemas = require('schemastore').json.schemas(),
                            validate = { enable = true },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                -- significatnly slower when adding this lne
                                -- library = vim.api.nvim_get_runtime_file('', true),
                                checkThirdParty = false,
                            },
                            diagnostics = {
                                global = { 'vim' },
                            },
                            codeLens = {
                                enable = true
                            },
                            completion = {
                                callSnippet = 'Replace'
                            },
                            doc = {
                                privateName = { '^_' },
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = 'Disable',
                                semicolon = 'Disable',
                                arrayIndex = 'Disable',
                            },
                            format = {
                                enable = true,
                                defaultConfig = {
                                    indent_style = 'space',
                                    indent_size = '2',
                                },
                            },
                        },
                    },
                },
            },
            -- you can do additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server: string, opts): boolean?>
            setup = {
                rust_analyzer = function(server, opts)
                    vim.g.rustaceanvim = {
                        tools = {},
                        server = {
                            on_attach = common.on_attach,
                            default_settings = {
                                ['rust-analyzer'] = {},
                            }
                        },
                        dap = {},
                    }
                    return true
                end,
                ['*'] = function(server, opts) end,
            },
        },
    }
}
