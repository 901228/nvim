local Map = Util.keymap.keymap
local SetGroupHint = Util.keymap.key_group

local opt = { noremap = true, silent = true }

-- flash
-- Map({ 'n', 'x', 'o' }, '<leader>ss', function() require('flash').jump() end, opt, 'Flash')
-- Map({ 'n', 'x', 'o' }, '<leader>sS', function() require('flash').treesitter() end, opt, 'Flash Treesitter')
-- Map('o', 'r', function() require('flash').remote() end, opt, 'Remote Flash')
-- Map({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, opt, 'Tresitter Search')
-- SetGroupHint('<leader>s', '+ flash')
