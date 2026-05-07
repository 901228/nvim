return {
    -- venv
    {
        'linux-cultist/venv-selector.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'nvim-telescope/telescope.nvim',
        },
        cmd = 'VenvSelect',
        ft = 'python',
        keys = {
            { '<leader>v', '<CMD>VenvSelect<CR>', desc = 'Select Venv', ft = 'python' },
        },
        opts = {
            notify_user_on_venv_activation = true,
            override_notify = true,
        },
    },

    -- nvim-lspconfig
    {
        'nvim-lspconfig',
        opts = {
            servers = {
                pyright = true,
                ruff = {
                    cmd_env = { RUFF_TRACE = 'messages' },
                    init_options = {
                        settings = {
                            logLevel = 'error',
                        },
                    },
                },
                ruff_lsp = true,
            },
            setup = {
                ruff = function(server, opts)
                    -- Snacks.util.lsp.on({ name = ruff }, function(_, client)
                    --     -- Disable hover in favor of Pyright
                    --     client.server_capabilities.hoverProvider = false
                    -- end)
                end,
            },
        },
    },
}
