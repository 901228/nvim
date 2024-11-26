return {
    -- code action
    {
        'luckasRanarison/clear-action.nvim',
        event = 'LazyFile',
        opts = {},
    },

    -- guess the indentation of the file
    {
        'NMAC427/guess-indent.nvim',
        event = 'LazyFile',
        opts = {},
    },

    -- rename
    {
        'smjonas/inc-rename.nvim',
        cmd = 'IncRename',
        opts = {},
    },
    {
        'noice.nvim',
        opts = {
            presets = { inc_rename = true },
        },
    },

    -- auto add brackets or something in pair
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {
            enable_check_bracket_line = true,
            ignored_text_char = '[%w%.]',
        },
    },

    -- comment lines or blocks
    {
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        opts = {},
        config = function(_, opts)
            opts.pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            require('Comment').setup(opts)
        end,
    },

    -- able to manipulate surround brackets or something
    {
        'echasnovski/mini.surround',
        keys = function(_, keys)
            local opts = Util.plugin.opts('mini.surround')
            local mappings = {
                { opts.mappings.add, desc = 'Add Surround', mode = { 'n', 'v' } },
                { opts.mappings.delete, desc = 'Delete Surround' },
                { opts.mappings.find, desc = 'Find Right Surround' },
                { opts.mappings.find_left, desc = 'Find Left Surround' },
                { opts.mappings.highlight, desc = 'Highlight Surround' },
                { opts.mappings.replace, desc = 'Replace Surround' },
                { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
                { 's', '', desc = 'Surround' },
            }
            mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = 'sa',
                delete = 'sd',
                find = 'sf',
                find_left = 'sF',
                highlight = 'sh',
                replace = 'sr',
                update_n_lines = 'sn',
            },
        },
    },

    -- beautiful and easier code folding system
    {
        'kevinhwang91/nvim-ufo',
        event = 'LazyFile',
        dependencies = { 'kevinhwang91/promise-async' },
        opts = function()
            local ftMap = {
                vim = 'indent',
                python = 'indent',
                git = '',
            }

            local virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local new_virt_text = {}
                local foldedLines = endLnum - lnum
                local suffix = (' 󰁂 %d '):format(foldedLines)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0

                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)

                    if targetWidth > curWidth + chunkWidth then
                        table.insert(new_virt_text, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(new_virt_text, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end

                    curWidth = curWidth + chunkWidth
                end

                table.insert(new_virt_text, { suffix, 'MoreMsg' })
                return new_virt_text
            end

            return {
                filetype_exclude = Util.plugin.non_editor_ft,
                close_fold_kinds_for_ft = {
                    default = { 'imports', 'comment' },
                    json = { 'array' },
                    c = { 'comment', 'region' },
                },
                fold_virt_text_handler = virt_text_handler,
                preview = {
                    win_config = {
                        border = { '', '─', '', '', '', '─', '', '' },
                    },
                    mappings = {
                        scrollU = '<C-u>',
                        scrollD = '<C-d>',
                        jumpTop = '[',
                        jumpBot = ']',
                    },
                },
                provider_selector = function(bufnr, filetype, buftype) return ftMap[filetype] end,
            }
        end,
        config = function(_, opts)
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('local_detach_ufo', { clear = true }),
                pattern = opts.filetype_exclude,
                callback = function() require('ufo').detach() end,
            })

            vim.opt.foldlevelstart = 99
            require('ufo').setup(opts)

            Util.keymap.key_group('z', 'folding')
            Util.keymap('n', 'zR', require('ufo').openAllFolds, {}, 'Unfold all')
            Util.keymap('n', 'zM', require('ufo').closeAllFolds, {}, 'Fold all')
            Util.keymap('n', 'zr', require('ufo').openFoldsExceptKinds, {}, 'Unfold')
            Util.keymap('n', 'zm', require('ufo').closeFoldsWith, {}, 'Fold')
            Util.keymap('n', 'zp', require('ufo').peekFoldedLinesUnderCursor, {}, 'Preview fold')
        end,
    },
}
