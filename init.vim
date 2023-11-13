
set background=dark
colorscheme zephyr

" basic
lua require('basic')

" Packer
lua require('plugins')

" key bindings
lua require('keybindings')

" gui font
lua require('gui')

" lsp
lua require('lsp/setup')
lua require('cmp/setup')

" plugins
lua require('plugin-config/nvim-tree')
lua require('plugin-config/bufferline')
lua require('plugin-config/web-devicons')
lua require('plugin-config/nvim-treesitter')
lua require('plugin-config/telescope')
lua require('plugin-config/comment')
lua require('plugin-config/lualine')
lua require('plugin-config/toggleterm')
lua require('plugin-config/alpha')
" lua require('plugin-config/symbols-outline')
lua require('plugin-config/nvim-autopairs')
lua require('plugin-config/illuminate')

