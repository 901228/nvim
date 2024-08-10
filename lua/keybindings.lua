local M = {}

-- leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local wk = require('which-key')

M.mappings = {}

local opt = { noremap = true, silent = true }
function Map(mode, lhs, rhs, opts, name)
    if name == nil then
        if type(rhs) == 'string' then
            name = rhs
        else
            name = ''
        end
    end

    local wk_opts = {
        lhs,
        rhs,
        desc = name,
        -- group = ,
        mode = mode,
        silent = opts.silent,
        noremap = opts.noremap,
        -- remap = not opts.noremap,
        nowait = opts.nowait,
        expr = opts.expr,
        buffer = opts.buffer,
    }

    -- wk.register( { [lhs] = { rhs, name } }, wk_opts )
    wk.add(wk_opts)
    table.insert(M.mappings, wk_opts)
end
M.Map = Map

function SetGroupHint(prefix, name)
    -- wk.register({ [prefix] = { name = name } })
    wk.add({ prefix, group = name })
    table.insert(M.mappings, { prefix, group = name })
end
M.SetGroupHint = SetGroupHint

-------------------------------------------------------------------------
-- Map(<mode>, <lhs>, <rhs>, opts, name)
--   mode   => normal, visual, insert, select, command-line, terminal ...
--   lhs    => key
--   rhs    => mapping function
--   opts   => silent, noremap, expr, buffer ...
--   name   => name to show on which-key
-------------------------------------------------------------------------
-- SetGroupHint(prefix, name)
--   prefix => prefix of this group
--   name   => name of this group
-------------------------------------------------------------------------

-- leader
Map("n", "<leader>w", "<CMD>w<CR>", opt, 'save')
Map("n", "<leader>q", "<CMD>q<CR>", opt, 'quit')
-- Map("n", "<leader>q", "<CMD>bd<CR>", opt, 'quit')
-- Map("n", "<leader>a", "<CMD>qall<CR>", opt, 'quit all')

-- alt + hjkl  窗口之间跳转
Map("n", "<A-h>", "<C-w>h", opt)
Map("n", "<A-j>", "<C-w>j", opt)
Map("n", "<A-k>", "<C-w>k", opt)
Map("n", "<A-l>", "<C-w>l", opt)

-- file explorers
Map("n", "<leader>nt", function() return require('neo-tree.command').execute({ toggle = true }) end, opt, 'toggle NeoTree')
Map("n", "<leader>nc", function() return require('neo-tree.command').execute({ action = 'focus' }) end, opt, 'focus NeoTree')
Map('n', '<leader>nf', function()
    local oil = require('oil')
    oil.toggle_float(oil.get_current_dir())
end, opt, 'open floating Oil')
SetGroupHint('<leader>n', '+ File Explorer')

-- format by nvimtree-sitter
Map("n", "<leader>i", "gg=G``", opt, 'auto format');

-- bufferline 左右Tab切换
Map("n", "<C-h>", "<CMD>BufferLineCyclePrev<CR>", opt)
Map("n", "<C-l>", "<CMD>BufferLineCycleNext<CR>", opt)

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

-- lsp keybinds
M.mapLSP = function(bufnr)

    local lsp_opt = {
        noremap = true,
        silen = true,
        buffer = bufnr,
    }

    local code_action = require('clear-action.actions')
    local conform = require('conform')

    SetGroupHint('<leader>l', '+ LSP actions')
    -- code action
    Map('n', '<leader>la', function() code_action.code_action() end, lsp_opt, 'code actions')
    -- go xx
    Map('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', lsp_opt, 'definition')
    Map('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', lsp_opt, 'hover')
    Map('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', lsp_opt, 'declaration')
    Map('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', lsp_opt, 'implementation')
    Map('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', lsp_opt, 'references')
    -- leader + =
    Map('n', '<leader>lf', function() conform.format() end, lsp_opt, 'format')
    -- map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', lsp_opt)
    -- map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', lsp_opt)
    -- map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', lsp_opt)
    -- map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', lsp_opt)
    -- map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', lsp_opt)
end

-- nvim-cmp auto completion
M.cmp = function(cmp)
    local enterBehavior = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
        else
            fallback()
        end
    end
    return {
        -- next candidated item
        ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        -- previous candidated item
        ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        -- show the completion list
        ['<A-.>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- cancel
        ['<A-,>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping({
            i = enterBehavior,
            s = cmp.mapping.confirm({ select = true }),
            c = enterBehavior,
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    -- cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, { 'i', 's', 'c' }),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    }
end

-- cmake-tools
Map("n", "<leader>cd", "<CMD>CMakeGenerate<CR><CMD>CMakeBuild<CR><CMD>CMakeRun<CR>", opt, 'Debug')
SetGroupHint('<leader>c', '+ CMake')

-- inc_rename
Map('n', '<leader>r', function() return ':IncRename ' .. vim.fn.expand('<cword>') end, { expr = true }, 'rename')

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
