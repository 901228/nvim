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
        lazy = false, -- This plugin is already lazy
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
            enabled = function() return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled end,
            integration = {
                lspconfig = true,
                cmp = true,
                coq = false,
            },
        },
    },

    -- python
    {
        'linux-cultist/venv-selector.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'nvim-telescope/telescope.nvim',
        },
        branch = 'regexp',
        cmd = 'VenvSelect',
        ft = 'python',
        keys = {
            { '<leader>v', '<CMD>VenvSelect<CR>', desc = 'Select Venv', ft = 'python' },
        },
        opts = function()
            return {
                dap_enabled = false,
                notify_user_on_activate = true,
            }
        end,
    },

    -- markdown
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'echasnovski/mini.icons',
        },
        opts = {},
    },

    -- lspconfig for langs
    {
        'nvim-lspconfig',
        opts = {
            -- lsp server settings
            servers = {
                -- <lsp server> = {
                --     mason = false, -- set to false if you don't want this server to be installed with mason
                --     keys = {}, -- add additional keymaps for specific lsp server
                -- },
                -- <lsp server> = true,

                clangd = true,
                cmake = true,
                rust_analyzer = true,
                dockerls = true,
                lemminx = true, -- xml
                pyright = true,
                cssls = { single_file_support = true },
                css_variables = true,

                -- jsonls = {
                --     settings = {
                --         json = {
                --             schemas = require('schemastore').json.schemas(),
                --             validate = { enable = true },
                --         },
                --     },
                -- },

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
                                enable = true,
                            },
                            completion = {
                                callSnippet = 'Replace',
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

                -- javascript/typescript
                vtsls = {
                    -- explicitly add default filetypes, so that we can extend them in related extras
                    filetypes = {
                        'javascript',
                        'javascriptreact',
                        'javascript.jsx',
                        'typescript',
                        'typescriptreact',
                        'typescript.tsx',
                    },
                    settings = {
                        complete_function_calls = true,
                        vtsls = {
                            enableMoveToFileCodeAction = true,
                            autoUseWorkspaceTsdk = true,
                            experimental = {
                                maxInlayHintLength = 30,
                                completion = {
                                    enableServerSideFuzzyMatch = true,
                                },
                            },
                        },
                        typescript = {
                            updateImportsOnFileMove = { enabled = 'always' },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                            inlayHints = {
                                enumMemberValues = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                parameterNames = { enabled = 'literals' },
                                parameterTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                variableTypes = { enabled = false },
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
                    local common = require('Mochi.plugins.lsp.common')
                    vim.g.rustaceanvim = {
                        tools = {},
                        server = {
                            on_attach = common.on_attach,
                            default_settings = {
                                ['rust-analyzer'] = {},
                            },
                        },
                        dap = {},
                    }
                    return true
                end,
                ['*'] = function(server, opts) end,
            },
        },
    },

    -- cmp for langs
    {
        'nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lua', -- { name = 'nvim_lua' }
        },
        opts = function(_, opts)
            if Util.plugin.has('lazydev.nvim') then
                table.insert(opts.sources, { name = 'lazydev', group_index = 0 })
            end

            if Util.plugin.has('cmp-nvim-lua') then
                table.insert(opts.sources, { name = 'nvim_lua', group_index = 0 })
            end
        end,
    },
}
