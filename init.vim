set background=dark
colorscheme zephyr

lua require('util')
lua require('types')
lua require('config')

" basic
lua require('basic')

" Packer
lua require('plugins')

" key bindings
lua require('keybindings')

" gui font
lua require('gui')

" lsp
lua require('lsp')

" plugins
lua require('plugin-config/telescope')
lua require('plugin-config/comment')
lua require('plugin-config/toggleterm')
lua require('plugin-config/nvim-autopairs')
lua require('plugin-config/illuminate')
lua require('plugin-config/noice')
" lua require('plugin-config/flash')
lua require('plugin-config/colorizer')
lua require('plugin-config/todo-comments')
lua require('plugin-config/trouble')
lua require('plugin-config/navic')
lua require('plugin-config/rainbows')
