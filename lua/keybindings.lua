local Map = Util.keymap.keymap
local SetGroupHint = Util.keymap.key_group

local opt = { noremap = true, silent = true }

-- telescope
local tel_builtin = require('telescope.builtin')
Map('n', '<leader>ff', tel_builtin.find_files, {}, 'find file')
Map('n', '<leader>fg', tel_builtin.live_grep, {}, 'find')
Map('n', '<leader>fb', tel_builtin.buffers, {}, 'find buffers')
Map('n', '<leader>fh', tel_builtin.help_tags, {}, 'helps')
Map('n', '<leader>fn', function()
    local tel = require('telescope')
    tel.load_extension('notify')
    tel.extensions.notify.notify()
end, {}, 'notify history')
Map('n', '<leader>fp', tel_builtin.commands, {}, 'commands')
Map('n', '<leader>fk', tel_builtin.keymaps, {}, 'keymaps')
SetGroupHint('<leader>f', '+ Telescope')

-- trouble
Map('n', '<leader>xx', function() require('trouble').toggle('diagnostics') end, opt, 'diagnostics')
Map('n', '<leader>xw', function() require('trouble').toggle('workspace_diagnostics') end, opt, 'workspace diagnostics')
Map('n', '<leader>xd', function() require('trouble').toggle('document_diagnostics') end, opt, 'document diagnostics')
Map('n', '<leader>xq', function() require('trouble').toggle('quickfix') end, opt, 'quickfix')
-- Map('n', '<leader>xl', function() require('trouble').toggle('loclist') end, opt, 'loclist')
Map('n', '<leader>xr', function() require('trouble').toggle('lsp_references') end, opt, 'symbol references')
SetGroupHint('<leader>x', '+ Truoble')

-- whitespace
Map('n', '<leader>k', require('whitespace-nvim').trim, opt, 'trim whitespaces')

-- flash
-- Map({ 'n', 'x', 'o' }, '<leader>ss', function() require('flash').jump() end, opt, 'Flash')
-- Map({ 'n', 'x', 'o' }, '<leader>sS', function() require('flash').treesitter() end, opt, 'Flash Treesitter')
-- Map('o', 'r', function() require('flash').remote() end, opt, 'Remote Flash')
-- Map({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, opt, 'Tresitter Search')
-- SetGroupHint('<leader>s', '+ flash')
