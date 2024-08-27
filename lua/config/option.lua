-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

-- preserve lines when scrolling
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4

-- line number
vim.wo.number = true
vim.wo.relativenumber = true

-- cursor highlight
vim.wo.cursorline = true

-- signs
vim.wo.signcolumn = "yes"

-- ruler
vim.wo.colorcolumn = "80"

-- tab
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.softtabstop = 4
vim.o.shiftround = true

vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4

vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true

-- search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.hlsearch = false
vim.o.incsearch = true

-- hide vim mode showing
vim.o.showmode = false

-- cmd height
vim.o.cmdheight = 2

-- auto read file when edited by outer process
vim.o.autoread = true
vim.bo.autoread = true

-- wrap
vim.o.wrap = false
vim.wo.wrap = false
vim.o.whichwrap = "b,s,<,>,[,],h,l"

-- hidden
vim.o.hidden = true

-- mouse
vim.o.mouse = "a"
vim.o.mousemoveevent = true

-- forbid backup
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- smaller update time
vim.o.updatetime = 300

-- wait for mappings
vim.o.timeoutlen = 1500
vim.o.ttimeoutlen = 100

-- split window will show from bottom-right
vim.o.splitbelow = true
vim.o.splitright = true

-- auto complete
vim.g.completeopt = "menu,menuone,noselect,noinsert"

-- themes
vim.o.background = "dark"
vim.o.termguicolors = true
vim.opt.termguicolors = true

-- control characters display
vim.o.list = true
vim.o.listchars = "tab:→\\ ,eol:↲,trail:·,extends:»,precedes:«,nbsp:×"

-- complete enhance
vim.wildmenu = true

-- don't pass messages to |ins-completion menu|
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.pumheight = 10

-- always show tabline
vim.o.showtabline = 2

-- some highlight settings
vim.api.nvim_set_hl(0, "NonText", { fg = "Blue" })
