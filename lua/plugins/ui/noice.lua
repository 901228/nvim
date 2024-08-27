return {
    -- panels of nvim
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nui.nvim',
            'nvim-notify',
            'nvim-cmp',
        },
        keys = {
            { '<leader>c',  '',                                                                            desc = '+ Noice' },
            { '<S-Enter>',  function() require('noice').redirect(vim.fn.getcmdline()) end,                 mode = 'c',            desc = 'Redirect Cmdline' },
            { '<leader>ch', function() require('noice').cmd('pick') end,                                   desc = 'Noice History' },
            { '<leader>cd', function() require('noice').cmd('dismiss') end,                                desc = 'Dismiss All' },
            { '<C-f>',      function() if not require('noice.lsp').scroll(4) then return '<C-f>' end end,  silent = true,         expr = true,              desc = 'Scoll Forward',  mode = { 'i', 'n', 's' } },
            { '<C-b>',      function() if not require('noice.lsp').scroll(-4) then return '<C-b>' end end, silent = true,         expr = true,              desc = 'Scoll Backward', mode = { 'i', 'n', 's' } },
        },
        opts = {
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = '%d+L, %d+B' },
                            { find = '; after #%d+' },
                            { find = '; before #%d+' },
                        },
                    },
                    view = 'mini',
                }
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
        },
        config = function(_, opts)
            -- start noice after Lazy installed plugin
            if vim.o.filetype == 'lazy' then
                vim.cmd([[messages clear]])
            end

            require('noice').setup(opts)
        end,
    },
}
