-- local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function()
    use 'wbthomason/packer.nvim'

    -- file explorer
    use {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        }
    }
    -- file manager
    use 'stevearc/oil.nvim'

    -- view many things in a panel
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        requires = 'nvim-lua/plenary.nvim'
    }
    -- comment lines or blocks
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    -- able to manipulate surround brackets or something
    use {
        'kylechui/nvim-surround',
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup()
        end
    }
    -- auto add brackets or something in pair
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end
    }

    ---- LSP ----
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    }
    -- nvim-cmp
    use 'hrsh7th/cmp-nvim-lsp' -- { name = nvim_lsp }
    use 'hrsh7th/cmp-buffer'   -- { name = 'buffer' },
    use 'hrsh7th/cmp-path'     -- { name = 'path' }
    use 'hrsh7th/cmp-cmdline'  -- { name = 'cmdline' }
    use 'hrsh7th/nvim-cmp'
    -- snippets
    use 'hrsh7th/cmp-nvim-lsp-signature-help' -- { name = 'nvim_lsp_signature_help' }
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-vsnip'    -- { name = 'vsnip' }
    use 'hrsh7th/vim-vsnip'
    use 'rafamadriz/friendly-snippets'
    -- lspkind
    use 'onsails/lspkind-nvim'
    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    --- language enhancement ---
    -- Lua
    use 'folke/neodev.nvim'
    -- Json
    use 'b0o/schemastore.nvim'
    -- CMake
    use 'Civitasv/cmake-tools.nvim'
    -- markdown
    -- use 'tadmccorkle/markdown.nvim'
    -- yuck (for eww)
    use 'elkowar/yuck.vim'

    --- others ---
    -- rename
    use {
        'smjonas/inc-rename.nvim',
        config = function() require('inc_rename').setup() end
    }

    ---- UI ----
    -- alpha
    use {
        'goolord/alpha-nvim',
        requires = 'nvim-tree/nvim-web-devicons',
    }
    -- ascii arts
    use {
        'MaximilianLloyd/ascii.nvim',
        requires = 'MunifTanjim/nui.nvim'
    }
    -- pretty list of LSP, quickfix, telescope ...
    use {
        'folke/trouble.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
    }
    -- navigation bar of functions
    use {
        'SmiteshP/nvim-navic',
        requires = 'neovim/nvim-lspconfig',
    }
    -- highlight other same words of thr word under cursor
    use 'RRethy/vim-illuminate'
    -- enhance some searching funcitons
    -- use 'folke/flash.nvim'
    -- quick look of f/F word moving
    use {
        'jinh0/eyeliner.nvim',
        config = function()
            require('eyeliner').setup({
                highlight_on_key = true,
                dim = true,
            })
        end
    }
    -- to indicate buffers
    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
    }
    use 'glepnir/zephyr-nvim'
    -- window status line & buffer name
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    -- popup terminals
    use {
        'akinsho/toggleterm.nvim',
        tag = '*',
    }
    -- notification system of nvim
    use 'rcarriga/nvim-notify'
    -- panels of nvim
    use {
        'folke/noice.nvim',
        requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
    }
    -- color highlighter
    use 'NvChad/nvim-colorizer.lua'
    -- toto highlight
    use {
        'folke/todo-comments.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    -- rainbow brackets
    use 'HiPhish/rainbow-delimiters.nvim'
    -- indent indicatior
    use 'lukas-reineke/indent-blankline.nvim'

    ---- Miscellaneous ----
    -- show keymaps
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end,
    }
    -- to increase or decrease numbers
    use {
        'zegervdv/nrpattern.nvim',
        config = function()
            require('nrpattern').setup()
        end,
    }
    -- to trim whitespaces
    use {
        'johnfrankmorgan/whitespace.nvim',
        config = function()
            require('whitespace-nvim').setup({
                highlight = 'DiffDelete',
                ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'alpha', 'toggleterm' },
                ignore_terminal = true,
                return_cursor = true,
            })
        end
    }
    -- animation of cursor moving
    use {
        'echasnovski/mini.animate',
        config = function()
            require('mini.animate').setup(
                require('plugin-config/mini_animate')()
            )
        end
    }
end)
