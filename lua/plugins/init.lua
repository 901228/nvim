Util.init()

return {
    { 'folke/lazy.nvim', version = '*' },
    { 'nvim-lua/plenary.nvim' },
    { 'MunifTanjim/nui.nvim' },
    -- view many things in a panel
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.4',
        dependencies = 'nvim-lua/plenary.nvim'
    },
    -- comment lines or blocks
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    -- able to manipulate surround brackets or something
    {
        'kylechui/nvim-surround',
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup()
        end
    },
    -- auto add brackets or something in pair
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end
    },

    ---- LSP ----
    -- nvim-cmp
    'hrsh7th/cmp-nvim-lsp', -- { name = nvim_lsp }
    'hrsh7th/cmp-buffer',   -- { name = 'buffer' },
    'hrsh7th/cmp-path',     -- { name = 'path' }
    'hrsh7th/cmp-cmdline',  -- { name = 'cmdline' }
    'hrsh7th/nvim-cmp',
    -- snippets
    'hrsh7th/cmp-nvim-lsp-signature-help', -- { name = 'nvim_lsp_signature_help' }
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-vsnip',    -- { name = 'vsnip' }
    'hrsh7th/vim-vsnip',
    'rafamadriz/friendly-snippets',
    -- lspkind
    'onsails/lspkind-nvim',
    -- formatting
    'stevearc/conform.nvim',

    ---- UI ----
    -- pretty list of LSP, quickfix, telescope ...
    {
        'folke/trouble.nvim',
        dependencies = 'nvim-web-devicons',
    },
    -- highlight other same words of thr word under cursor
    -- 'RRethy/vim-illuminate',
    -- enhance some searching funcitons
    -- use 'folke/flash.nvim'
    -- quick look of f/F word moving
    {
        'jinh0/eyeliner.nvim',
        config = function()
            require('eyeliner').setup({
                highlight_on_key = true,
                dim = true,
            })
        end
    },
    'glepnir/zephyr-nvim',
    -- popup terminals
    {
        'akinsho/toggleterm.nvim',
        version = '*',
    },
    -- panels of nvim
    {
        'folke/noice.nvim',
        dependencies = { 'nui.nvim', 'nvim-notify' }
    },
    -- color highlighter
    'NvChad/nvim-colorizer.lua',
    -- toto highlight
    {
        'folke/todo-comments.nvim',
        dependencies = 'plenary.nvim',
    },
    -- transparent
    -- use {
    --     'xiyaowong/transparent.nvim',
    --     config = function()
    --         require('transparent').setup()
    --     end
    -- }

    ---- Miscellaneous ----
    -- show keymaps
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end,
    },
    -- to increase or decrease numbers
    {
        'zegervdv/nrpattern.nvim',
        config = function()
            require('nrpattern').setup()
        end,
    },
    -- to trim whitespaces
    {
        'johnfrankmorgan/whitespace.nvim',
        config = function()
            require('whitespace-nvim').setup({
                highlight = 'DiffDelete',
                ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'alpha', 'toggleterm' },
                ignore_terminal = true,
                return_cursor = true,
            })
        end
    },
    -- animation of cursor moving
    {
        'echasnovski/mini.animate',
        config = function()
            require('mini.animate').setup(
                require('plugin-config/mini_animate')()
            )
        end
    },
}
