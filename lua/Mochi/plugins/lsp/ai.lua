return {
    {
        'supermaven-inc/supermaven-nvim',
        event = 'InsertEnter',
        cmd = { 'SupermavenUseFree', 'SupermavenUsePro' },
        opts = {
            keymaps = {
                accept_suggestion = nil, -- handled by blink.cmp
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
                -- suggestion_color = Util.color.get_color_from_group('BlinkCmpGhostText'),
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
        'saghen/blink.cmp',
        dependencies = { 'supermaven-nvim', 'saghen/blink.compat' },
        opts = {
            sources = {
                compat = { 'supermaven' },
                providers = {
                    supermaven = {
                        -- FIXME: kind_icon
                        name = 'supermaven',
                        module = 'blink.compat.source',
                        score_offset = 100,
                        async = true,
                        kind = 'Supermaven',
                    },
                },
            },
        },
    },

    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        opts = function(_, opts) table.insert(opts.sections.lualine_x, 2, Util.ui.lualine.cmp_source('supermaven')) end,
    },

    {
        'folke/noice.nvim',
        optional = true,
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
