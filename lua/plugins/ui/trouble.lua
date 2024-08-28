return {
    -- pretty list of LSP, quickfix, telescope ...
    {
        'folke/trouble.nvim',
        cmd = 'Trouble',
        opts = {
            modes = {
                lsp = {
                    win = { position = 'right' },
                },
            },
        },
        -- stylua: ignore
        keys = {
            { '<leader>x', desc = '+ Truoble' },
            { '<leader>xx', function() require('trouble').toggle('diagnostics') end, desc = 'Diagnostics' },
            -- { '<leader>xw', function() require('trouble').toggle('workspace_diagnostics') end, desc = 'Workspace Diagnostics' },
            -- { '<leader>xd', function() require('trouble').toggle('document_diagnostics') end, desc = 'Document Diagnostics' },
            -- { '<leader>xq', function() require('trouble').toggle('quickfix') end, desc = 'quickfix' },
            { '<leader>xl', function() require('trouble').toggle('lsp') end, desc = 'lsp' },
            {
                '[q',
                function()
                    if require('trouble').is_open() then
                        ---@diagnostic disable-next-line: missing-parameter, missing-fields
                        require('trouble').prev({ skip_groups = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            Util.error(err)
                        end
                    end
                end,
                desc = 'Previous Trouble/Quickfix Item',
            },
            {
                ']q',
                function()
                    if require('trouble').is_open() then
                        ---@diagnostic disable-next-line: missing-parameter, missing-fields
                        require('trouble').next({ skip_groups = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            Util.error(err)
                        end
                    end
                end,
                desc = 'Next Trouble/Quickfix Item',
            },
        },
    },
}
