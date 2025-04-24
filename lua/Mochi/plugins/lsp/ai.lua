return {
    {
        'supermaven-inc/supermaven-nvim',
        dependencies = { 'hrsh7mth/nvim-cmp' },
        event = 'InsertEnter',
        cmd = { 'SupermavenUseFree', 'SupermavenUsePro' },
        opts = {
            keymaps = {
                accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
            },
            disable_inline_completion = vim.g.ai_cmp,
            ignore_filetypes = {
                'bigfile',
                'snacks_input',
                'snacks_notif',
            },
            color = {
                -- HACK: use color code directly insread of hl color
                suggestion_color = '#9399b2',
                -- suggestion_color = Util.color.get_color_from_group('CmpGhostText'),
                cterm = 244,
            },
        },
    },

    -- add ai_accept action
    {
        'supermaven-inc/supermaven-nvim',
        opts = function()
            require('supermaven-nvim.completion_preview').suggestion_group = 'SupermavenSuggestion'
            Util.cmp.actions.ai_accept = function()
                local suggestion = require('supermaven-nvim.completion_preview')
                if suggestion.has_suggestion() then
                    Util.create_undo()
                    vim.schedule(function() suggestion.on_accept_suggestion() end)
                    return true
                end
            end
        end,
    },

    -- cmp integration
    {
        'hrsh7mth/nvim-cmp',
        dependencies = { 'supermaven-nvim' },
        opts = function(_, opts)
            table.insert(opts.sources, 1, {
                name = 'supermaven',
                group_index = 1,
                priority = 100,
            })
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        opts = function(_, opts) table.insert(opts.sections.lualine_x, 2, Util.ui.lualine.cmp_source('supermaven')) end,
    },

    {
        'folke/noice.nvim',
        opts = function(_, opts)
            vim.list_extend(opts.routes, {
                {
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = 'Starting Supermaven' },
                            { find = 'Supermaven Free Tier' },
                        },
                    },
                    skip = true,
                },
            })
        end,
    },
}
