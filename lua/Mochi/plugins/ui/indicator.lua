local highlight = {
    'RainbowRed',
    'RainbowYellow',
    'RainbowBlue',
    'RainbowOrange',
    'RainbowGreen',
    'RainbowViolet',
    'RainbowCyan',
}

return {
    -- indent indicator
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'LazyFile',
        opts = {
            scope = { highlight = highlight },
            exclude = { filetypes = Util.plugin.non_editor_ft },
        },
        config = function(_, opts)
            local hooks = require('ibl.hooks')
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
                vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
                vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
                vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
                vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
                vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
                vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
            end)

            require('ibl').setup(opts)

            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end,
    },

    -- rainbow brackets
    {
        'HiPhish/rainbow-delimiters.nvim',
        event = 'LazyFile',
        opts = {
            highlight = highlight,
            blacklist = Util.plugin.non_editor_ft,
        },
        config = function(_, opts) require('rainbow-delimiters.setup').setup(opts) end,
    },

    -- gitsigns
    {
        'lewis6991/gitsigns.nvim',
        event = 'LazyFile',
        init = function()
            Util.keymap.key_group('<leader>g', 'Git', { icon = '󰊢' })
            Util.keymap.key_group('<leader>gh', 'Git Hunk', { icon = '󰗈' })
        end,
        opts = {
            signs = {
                add = { text = '▎' },
                change = { text = '▎' },
                delete = { text = '' },
                topdelete = { text = '' },
                changedelete = { text = '▎' },
                untracked = { text = '▎' },
            },
            signs_staged = {
                add = { text = '▎' },
                change = { text = '▎' },
                delete = { text = '' },
                topdelete = { text = '' },
                changedelete = { text = '▎' },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, lhs, rhs, desc) Util.keymap(mode, lhs, rhs, { buffer = buffer }, desc) end

                map('n', ']h', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gs.nav_hunk('next')
                    end
                end, 'Next Hunk')
                map('n', '[h', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gs.nav_hunk('prev')
                    end
                end, 'Prev Hunk')
                map('n', ']H', function() gs.nav_hunk('last') end, 'Last Hunk')
                map('n', '[H', function() gs.nav_hunk('first') end, 'First Hunk')
                map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
                map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
                -- map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
                map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
                -- map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
                map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
                map('n', '<leader>ghP', gs.preview_hunk, 'Preview Hunk')
                map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, 'Blame Line')
                map('n', '<leader>ghB', function() gs.blame() end, 'Blame Buffer')
                -- map('n', '<leader>ghd', gs.diffthis, 'Diff This')
                -- map('n', '<leader>ghD', function() gs.diffthis('~') end, 'Diff This ~')
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
            end,
        },
    },
}
