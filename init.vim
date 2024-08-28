set background=dark
colorscheme zephyr

lua require('util')
lua require('types')
lua require('config')

" key bindings
lua require('keybindings')

" plugins
lua require('plugin-config/telescope')
" lua require('plugin-config/flash')
lua require('plugin-config/colorizer')
