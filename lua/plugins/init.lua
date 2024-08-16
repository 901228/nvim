return {
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
    {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    },
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
    -- code action
    'luckasRanarison/clear-action.nvim',
    -- formatting
    'stevearc/conform.nvim',

    --- language enhancement ---
    -- Lua
    'folke/neodev.nvim',
    -- Json
    'b0o/schemastore.nvim',
    -- CMake
    'Civitasv/cmake-tools.nvim',
    -- markdown
    -- use 'tadmccorkle/markdown.nvim'
    -- yuck (for eww)
    'elkowar/yuck.vim',
    -- Rust
    {
        'mrcjkb/rustaceanvim',
        bufread = true,
        ft = { 'rust', 'rs' },
    },

    --- others ---
    -- rename
    {
        'smjonas/inc-rename.nvim',
        config = function() require('inc_rename').setup() end
    },

    ---- UI ----
    -- pretty list of LSP, quickfix, telescope ...
    {
        'folke/trouble.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
    },
    -- navigation bar of functions
    {
        'SmiteshP/nvim-navic',
        dependencies = 'neovim/nvim-lspconfig',
    },
    -- highlight other same words of thr word under cursor
    'RRethy/vim-illuminate',
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
        dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
    },
    -- color highlighter
    'NvChad/nvim-colorizer.lua',
    -- toto highlight
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
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
