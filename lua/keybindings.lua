local M = {}

-- leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local wk = require('which-key')

local keymap = vim.api.nvim_set_keymap
local keyset = vim.keymap.set
local opt = { noremap = true, silent = true }
function Map(mode, lhs, rhs, opts, name)
    -- if type(rhs) == 'string' then
    --     keymap(mode, lhs, rhs, opts)
    -- elseif type(rhs) == 'function' then
    --     keyset(mode, lhs, rhs, opts)
    -- end

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
Map("n", "<leader>w", ":w<CR>", opt, 'save')
Map("n", "<leader>q", ":q<CR>", opt, 'quit')

-- alt + hjkl  窗口之间跳转
Map("n", "<A-h>", "<C-w>h", opt)
Map("n", "<A-j>", "<C-w>j", opt)
Map("n", "<A-k>", "<C-w>k", opt)
Map("n", "<A-l>", "<C-w>l", opt)

-- nvimTree
Map("n", "<leader>rt", function() return require("nvim-tree.api").tree.toggle() end, opt, 'toggle NvimTree')
Map("n", "<leader>rc", function() return require("nvim-tree.api").tree.focus() end, opt, 'focus NvimTree')
SetGroupHint('<leader>r', '+ NvimTree')

-- format by nvimtree-sitter
Map("n", "<leader>i", "gg=G``", opt, 'auto format');

-- bufferline 左右Tab切换
Map("n", "<C-h>", ":BufferLineCyclePrev<CR>", opt)
Map("n", "<C-l>", ":BufferLineCycleNext<CR>", opt)

local builtin = require('telescope.builtin')
Map('n', '<leader>ff', builtin.find_files, {}, 'find file')
Map('n', '<leader>fg', builtin.live_grep, {}, 'find')
Map('n', '<leader>fb', builtin.buffers, {}, 'find buffers')
Map('n', '<leader>fh', builtin.help_tags, {}, 'helps')
SetGroupHint('<leader>f', '+ Telescope')

-- lsp 回调函数快捷键设置
M.maplsp = function(bufnr)

    local lsp_opt = {
        noremap = true,
        silen = true,
        buffer = bufnr,
    }

    -- rename
    Map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', lsp_opt)
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
Map("n", "<leader>cd", ":CMakeGenerate<CR>:CMakeBuild<CR>:CMakeRun<CR>", opt, 'Debug')
SetGroupHint('<leader>c', '+ CMake')

-- source
Map("n", "<leader>s", ":source $MYVIMRC<CR>", opt, 'Reload Neovim')

return M
