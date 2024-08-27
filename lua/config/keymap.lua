local opts = { noremap = true, silent = true }

Util.keymap('n', '<leader>w', '<CMD>w<CR>', opts, 'save')
Util.keymap('n', '<leader>q', '<CMD>q<CR>', opts, 'quit')

-- move between windows(panes)
Util.keymap('n', '<A-h>', '<C-w>h', opts, 'move left')
Util.keymap('n', '<A-j>', '<C-w>j', opts, 'move down')
Util.keymap('n', '<A-k>', '<C-w>k', opts, 'move up')
    Util.keymap('n', '<A-l>', '<C-w>l', opts, 'move right')

-- groups
Util.keymap.key_group('<leader>n', '+ File Explorer')
