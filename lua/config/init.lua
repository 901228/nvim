require('config.bootstrap')

-- leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require('config.lazy')

Util.format.setup()

require('config.option')
require('config.keymap')
