-- leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

Util.keymap('n', '<leader>w', '<CMD>w<CR>', {}, 'save')
Util.keymap('n', '<leader>q', '<CMD>q<CR>', {}, 'quit')

-- move between windows(panes)
Util.keymap('n', '<A-h>', '<C-w>h', {}, 'move left')
Util.keymap('n', '<A-j>', '<C-w>j', {}, 'move down')
Util.keymap('n', '<A-k>', '<C-w>k', {}, 'move up')
Util.keymap('n', '<A-l>', '<C-w>l', {}, 'move right')
