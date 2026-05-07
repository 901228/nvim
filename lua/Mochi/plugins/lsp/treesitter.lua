return {
    {
        'romus204/tree-sitter-manager.nvim',
        build = function()
            local ok = vim.fn.executable('tree-sitter') == 1
            if ok then
                vim.notify('tree-sitter-cli already installed, skipping', vim.log.levels.INFO)
                return
            end
            local result = vim.system({ 'cargo', 'binstall', '--no-confirm', 'tree-sitter-cli' }):wait()
            if result.code ~= 0 then
                vim.notify('Failed to install tree-sitter-cli:\n' .. (result.stderr or ''), vim.log.levels.ERROR)
            else
                vim.notify('tree-sitter-cli installed successfully', vim.log.levels.INFO)
            end
        end,
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        event = { 'BufReadPost', 'BufNewFile' },
        keys = {
            { '<CR>', Util.treesitter.init_selection, mode = 'n', desc = 'Increment Selection' },
            { '<CR>', Util.treesitter.node_incremental, mode = 'x', desc = 'Increment Selection' },
            { '<BS>', Util.treesitter.node_decremental, mode = 'x', desc = 'Decrement Selection' },
        },
        config = function()
            require('tree-sitter-manager').setup({
                ensure_installed = {
                    -- 'bash',
                    -- 'c',
                    -- 'cmake',
                    -- 'cpp',
                    -- 'diff',
                    -- 'dockerfile',
                    -- 'dot',
                    -- 'jsdoc',
                    -- 'json',
                    -- 'lua',
                    -- 'luadoc',
                    -- 'luap',
                    -- 'markdown',
                    -- 'markdown_inline',
                    -- 'printf',
                    -- 'python',
                    -- 'query',
                    -- 'regex',
                    -- 'toml',
                    -- 'vim',
                    -- 'vimdoc',
                    -- 'xml',
                    -- 'yaml',
                },
                auto_install = true,
                highlight = false,
                language = {},
            })

            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    -- if the file is too large, treesitter will be disabled
                    if Util.is_large_file() then return end

                    pcall(vim.treesitter.start)
                    vim.bo.indentexpr = 'v:lua.vim.treesitter.indentexpr()' -- NOTE: experimental indentation support
                end,
            })

            -- fold
            vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'
        end,
    },

    -- textobjects
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        event = 'VeryLazy',
        enabled = true,
        opts = {
            move = {
                set_jumps = true,
            },
        },
        keys = {
            {
                ']f',
                function() Util.treesitter.goto_next_start('@function.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to next function start',
            },
            {
                ']c',
                function() Util.treesitter.goto_next_start('@class.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to next class start',
            },
            {
                ']a',
                function() Util.treesitter.goto_next_start('@parameter.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to next parameter start',
            },
            {
                ']F',
                function() Util.treesitter.goto_next_end('@function.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to next function end',
            },
            {
                ']C',
                function() Util.treesitter.goto_next_end('@class.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to next class end',
            },
            {
                ']A',
                function() Util.treesitter.goto_next_end('@parameter.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to next parameter end',
            },
            {
                '[f',
                function() Util.treesitter.goto_previous_start('@function.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to previous function start',
            },
            {
                '[c',
                function() Util.treesitter.goto_previous_start('@class.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to previous class start',
            },
            {
                '[a',
                function() Util.treesitter.goto_previous_start('@parameter.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to previous parameter start',
            },
            {
                '[F',
                function() Util.treesitter.goto_previous_end('@function.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to previous function end',
            },
            {
                '[C',
                function() Util.treesitter.goto_previous_end('@class.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to previous class end',
            },
            {
                '[A',
                function() Util.treesitter.goto_previous_end('@parameter.outer', 'textobjects') end,
                mode = { 'n', 'x', 'o' },
                desc = 'Go to previous parameter end',
            },
        },
        config = function(_, opts)
            require('nvim-treesitter-textobjects').setup(opts)

            local move = require('nvim-treesitter-textobjects.move') ---@type table<string, fun(...)>
            for name, fn in pairs(move) do
                if name:find('goto') == 1 then
                    move[name] = function(q, ...)
                        if vim.wo.diff and (q == '@class.outer' or q == '@class.inner') then
                            local key_map = {
                                ['@class.outer'] = { next_start = ']c', prev_start = '[c' },
                            }
                            local keys = key_map[q]
                            if keys then
                                vim.cmd('normal! ' .. (name:find('next') and keys.next_start or keys.prev_start))
                                return
                            end
                        end
                        return fn(q, ...)
                    end
                end
            end
        end,
    },
}
