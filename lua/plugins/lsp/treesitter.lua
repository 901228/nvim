return {
    {
        'folke/which-key.nvim',
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
        },
        config = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                opts.ensure_installed = Util.dedup(opts.ensure_installed)
            end
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
}
