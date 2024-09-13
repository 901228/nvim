return {
    {
        'which-key.nvim',
        opts = {
            spec = {
                { '<BS>', desc = 'Decrement Selection', mode = 'x' },
                { '<CR>', desc = 'Increment Selection', mode = { 'x', 'n' } },
            },
        },
    },

    -- Treesitter is a new parser generator tool that we can
    -- use in Neovim to power faster and more accurate
    -- syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        version = false, -- last release is way too old and doesn't work on Windows
        build = ':TSUpdate',
        event = { 'LazyFile', 'VeryLazy' },
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        init = function(plugin)
            require('lazy.core.loader').add_to_rtp(plugin)
            require('nvim-treesitter.query_predicates')
        end,
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
        opts_extend = { 'ensure_installed' },
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                language_tree = true,
                is_supported = function()
                    return not Util.is_large_file()
                end,
            },
            indent = { enable = true },
            sync_install = false,
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
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    node_incremental = '<CR>',
                    node_decremental = '<BS>',
                    scope_incremental = '<TAB>',
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = {
                        [']f'] = '@function.outer',
                        [']c'] = '@class.outer',
                        [']a'] = '@parameter.inner',
                    },
                    goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
                    goto_previous_start = {
                        ['[f'] = '@function.outer',
                        ['[c'] = '@class.outer',
                        ['[a'] = '@parameter.inner',
                    },
                    goto_previous_end = {
                        ['[F'] = '@function.outer',
                        ['[C'] = '@class.outer',
                        ['[A'] = '@parameter.inner',
                    },
                },
            },
        },
        config = function(_, opts)
            -- fold
            vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'

            if type(opts.ensure_installed) == 'table' then opts.ensure_installed = Util.dedup(opts.ensure_installed) end
            require('nvim-treesitter.configs').setup(opts)
        end,
    },

    -- textobjects
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        event = 'VeryLazy',
        enabled = true,
        config = function()
            if Util.plugin.is_loaded('nvim-treesitter') then
                local opts = Util.plugin.opts('nvim-treesitter')
                require('nvim-treesitter.configs').setup({ textobjects = opts.textobjects })
            end

            local move = require('nvim-treesitter.textobjects.move') ---@type table<string, fun(...)>
            local configs = require('nvim-treesitter.configs')
            for name, fn in ipairs(move) do
                if name:find('goto') == 1 then
                    move[name] = function(q, ...)
                        if vim.wo.diff then
                            local config = configs.get_module('textobjects.move')[name] ---@type table<string, string>
                            for key, query in pairs(config or {}) do
                                if q == query and key:find('[%]%[][cC]') then
                                    vim.cmd('normal!' .. key)
                                    return
                                end
                            end
                        end
                        return fn(q, ...)
                    end
                end
            end
        end,
    },
}
