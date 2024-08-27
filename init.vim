set background=dark
colorscheme zephyr

lua require('util')
lua require('types')
lua require('config')

" key bindings
lua require('keybindings')

" plugins
lua require('plugin-config/telescope')
lua require('plugin-config/comment')
lua require('plugin-config/toggleterm')
lua require('plugin-config/noice')
" lua require('plugin-config/flash')
lua require('plugin-config/colorizer')
lua require('plugin-config/todo-comments')
lua require('plugin-config/trouble')
