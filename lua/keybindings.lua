local M = {}

local Map = Util.keymap.keymap
local SetGroupHint = Util.keymap.key_group

local opt = { noremap = true, silent = true }

-- leader
Map("n", "<leader>w", "<CMD>w<CR>", opt, 'save')
Map("n", "<leader>q", "<CMD>q<CR>", opt, 'quit')
-- Map("n", "<leader>a", "<CMD>qall<CR>", opt, 'quit all')

-- alt + hjkl  窗口之间跳转
Map("n", "<A-h>", "<C-w>h", opt)
Map("n", "<A-j>", "<C-w>j", opt)
Map("n", "<A-k>", "<C-w>k", opt)
Map("n", "<A-l>", "<C-w>l", opt)

-- file explorers
SetGroupHint('<leader>n', '+ File Explorer')

Map("n", "<leader>i", function() Util.format() end, opt, 'format');

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

-- nvim-cmp auto completion
-- M.cmp = function(cmp)
--     local enterBehavior = function(fallback)
--         if cmp.visible() and cmp.get_active_entry() then
--             cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
--         else
--             fallback()
--         end
--     end
--     return {
--         -- next candidated item
--         ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
--         -- previous candidated item
--         ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
--         -- show the completion list
--         ['<A-.>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
--         -- cancel
--         ['<A-,>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
--         -- Accept currently selected item. If none selected, `select` first item.
--         -- Set `select` to `false` to only confirm explicitly selected items.
--         ['<CR>'] = cmp.mapping({
--             i = enterBehavior,
--             s = cmp.mapping.confirm({ select = true }),
--             c = enterBehavior,
--         }),
--         ['<Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 local entry = cmp.get_selected_entry()
--                 if not entry then
--                     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
--                     -- cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
--                 else
--                     cmp.confirm()
--                 end
--             else
--                 fallback()
--             end
--         end, { 'i', 's', 'c' }),
--         -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
--         -- ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
--         -- ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
--     }
-- end

-- flash
-- Map({ 'n', 'x', 'o' }, '<leader>ss', function() require('flash').jump() end, opt, 'Flash')
-- Map({ 'n', 'x', 'o' }, '<leader>sS', function() require('flash').treesitter() end, opt, 'Flash Treesitter')
-- Map('o', 'r', function() require('flash').remote() end, opt, 'Remote Flash')
-- Map({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, opt, 'Tresitter Search')
-- SetGroupHint('<leader>s', '+ flash')

-- tests
Map('n', '<leader>da', function() print(vim.fn.filereadable(vim.api.nvim_buf_get_name(0))) end, opt)
-- Map('n', '<leader>db', function() require('plugin-config.nvim-tree').get_file_buffers() end, opt)
Map('n', '<leader>dc', function() vim.api.nvim_set_current_buf(1) end, opt)
Map('n', '<leader>dd', function ()
    local to_print = 'wins: ' .. #vim.api.nvim_list_wins() .. ': '
    for k, v in pairs(vim.api.nvim_list_wins()) do
        to_print = to_print .. '(' .. k .. ', ' .. v .. '), '
    end
    print(to_print)
end, opt)
Map('n', '<leader>de', function ()
    local to_print = 'real wins: '
    for _, v in pairs(vim.api.nvim_list_wins()) do
        local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(v))
        if name ~= nil and vim.fn.filereadable(name) == 1 then
            to_print = to_print .. v .. ', '
        end
    end
    print(to_print)
end, opt)
Map('n', '<leader>df', function()
    print(vim.api.nvim_get_current_win())
end, opt)
SetGroupHint('<leader>d', '+ Debug Functions')

return M
