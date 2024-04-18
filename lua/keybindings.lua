local M = {}

-- leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local wk = require('which-key')

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
        mode = mode,
        silent = opts.silent,
        noremap = opts.noremap,
        nowait = opts.nowait,
        expr = opts.expr,
        buffer = opts.buffer,
    }

    wk.register( { [lhs] = { rhs, name } }, wk_opts )
end
M.Map = Map

function SetGroupHint(prefix, name)
    wk.register({ [prefix] = { name = name } })
end
M.SetGroupHint = SetGroupHint

-- map(<mode>, <lhs>, <rhs>, opts)
-- keyset(<mode>, <lhs>, <rhs>, opts)
-- mode => normal, visual, insert, select, command-line, terminal ...
--  lhs => key
--  rhs => mapping function
--  opts => silent, noremap, expr, buffer ...
--  name => name to show on which-key

-- leader
Map("n", "<leader>w", "<CMD>w<CR>", opt, 'save')
Map("n", "<leader>q", "<CMD>q<CR>", opt, 'quit')
-- Map("n", "<leader>q", "<CMD>bd<CR>", opt, 'quit')
Map("n", "<leader>a", "<CMD>qall<CR>", opt, 'quit all')

-- alt + hjkl  窗口之间跳转
Map("n", "<A-h>", "<C-w>h", opt)
Map("n", "<A-j>", "<C-w>j", opt)
Map("n", "<A-k>", "<C-w>k", opt)
Map("n", "<A-l>", "<C-w>l", opt)

-- file explorers
Map("n", "<leader>nt", function() return require('neo-tree.command').execute({ toggle = true }) end, opt, 'toggle NeoTree')
Map("n", "<leader>nc", function() return require('neo-tree.command').execute({ action = 'focus' }) end, opt, 'focus NeoTree')
-- TODO: open oil
Map('n', '<leader>nf', function() return 'todo with oil' end, opt, 'open floating Oil')
SetGroupHint('<leader>n', '+ File Explorer')

-- format by nvimtree-sitter
Map("n", "<leader>i", "gg=G``", opt, 'auto format');

-- bufferline 左右Tab切换
Map("n", "<C-h>", "<CMD>BufferLineCyclePrev<CR>", opt)
Map("n", "<C-l>", "<CMD>BufferLineCycleNext<CR>", opt)

-- telescope
local builtin = require('telescope.builtin')
Map('n', '<leader>ff', builtin.find_files, {}, 'find file')
Map('n', '<leader>fg', builtin.live_grep, {}, 'find')
Map('n', '<leader>fb', builtin.buffers, {}, 'find buffers')
Map('n', '<leader>fh', builtin.help_tags, {}, 'helps')
SetGroupHint('<leader>f', '+ Telescope')

-- trouble
-- Map('n', '<leader>xx', function() require('trouble').toggle() end, opt, 'trouble')
Map('n', '<leader>xw', function() require('trouble').toggle('workspace_diagnostics') end, opt, 'workspace diagnostics')
Map('n', '<leader>xd', function() require('trouble').toggle('document_diagnostics') end, opt, 'document diagnostics')
Map('n', '<leader>xq', function() require('trouble').toggle('quickfix') end, opt, 'quickfix')
-- Map('n', '<leader>xl', function() require('trouble').toggle('loclist') end, opt, 'loclist')
Map('n', '<leader>xr', function() require('trouble').toggle('lsp_references') end, opt, 'symbol references')
SetGroupHint('<leader>x', '+ Truoble')

-- lsp 回调函数快捷键设置
M.mapLSP = function(bufnr)

    local lsp_opt = {
        noremap = true,
        silen = true,
        buffer = bufnr,
    }

    -- rename
    -- Map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', lsp_opt)
    -- code action
    Map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', lsp_opt)
    -- go xx
    Map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', lsp_opt)
    Map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', lsp_opt)
    Map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', lsp_opt)
    Map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', lsp_opt)
    Map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', lsp_opt)
    -- diagnostic
    Map('n', 'go', '<cmd>lua vim.diagnostic.open_float()<CR>', lsp_opt)
    Map('n', 'gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', lsp_opt)
    Map('n', 'gn', '<cmd>lua vim.diagnostic.goto_next()<CR>', lsp_opt)
    -- map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', lsp_opt)
    -- leader + =
    Map('n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', lsp_opt)
    -- map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', lsp_opt)
    -- map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', lsp_opt)
    -- map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', lsp_opt)
    -- map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', lsp_opt)
    -- map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', lsp_opt)
end

-- nvim-cmp 自动补全
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

-- source
Map("n", "<leader>s", "<CMD>source $MYVIMRC<CR>", opt, 'Reload Neovim')

-- inc_rename
Map('n', '<leader>r', function() return ':IncRename ' .. vim.fn.expand('<cword>') end, { expr = true }, 'Rename')

-- flash
Map({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, opt, 'Flash')
Map({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, opt, 'Flash Treesitter')
Map('o', 'r', function() require('flash').remote() end, opt, 'Remote Flash')
Map({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, opt, 'Tresitter Search')
Map('c', '<C-s>', function() require('flash').toggle() end, opt, 'Toggle Flash Search')

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
    for k, v in pairs(vim.api.nvim_list_wins()) do
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
