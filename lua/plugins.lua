-- local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function()
    use 'wbthomason/packer.nvim'
    use {
        'nvim-tree/nvim-tree.lua',
        requires = 'nvim-tree/nvim-web-devicons',
        -- cmd = { "NvimTreeToggle", "NvimTreeRefresh", "NvimTreeFocus" },
        opt = true,
        config = function() require'nvim-tree'.setup {} end
    }
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        requires = 'nvim-lua/plenary.nvim'
    }
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup {} end
    }
    use {
        'kylechui/nvim-surround',
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function() require("nvim-surround").setup {} end
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

    --- language enhancement ---
    -- Lua
    use 'folke/neodev.nvim'
    -- Json
    use 'b0o/schemastore.nvim'
    -- CMake
    use 'Civitasv/cmake-tools.nvim'

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
    -- symbol table
    -- use 'simrat39/symbols-outline.nvim'
    -- pretty list of LSP, quickfix, telescope ...
    use {
        'folke/trouble.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        config = function() require('trouble').setup {} end
    }
    use 'RRethy/vim-illuminate'
    use { 'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use 'glepnir/zephyr-nvim'
    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup {} end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use {
        'akinsho/toggleterm.nvim',
        tag = '*',
        -- config = function() require('toggleterm').setup {} end
    }
    use {
        'folke/noice.nvim',
        requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
    }

    ---- Miscellaneous ----
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {}
        end
    }

end)
