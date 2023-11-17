require('toggleterm').setup {
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.3
        end
    end,
    shade_terminals = false,
    float_opts = {
        border = 'curved'
    },
    start_in_insert = true,
}

local Terminal  = require('toggleterm.terminal').Terminal
local map = require('keybindings').Map

local lazygit = Terminal:new {
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    float_opts = {
        border = "double",
    },
    on_open = function(term)
        vim.cmd("startinsert!")
        -- q / <leader>tg 关闭 terminal
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        map("n", "<leader>tg", "<cmd>close<CR>", { noremap = true, silent = true, buffer = term.bufnr })
        -- ESC 键取消，留给lazygit
        if vim.fn.mapcheck("<Esc>", "t") ~= "" then
            vim.api.nvim_del_keymap("t", "<Esc>")
        end
    end,
    on_close = function(_)
        -- 添加回来
        vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {
            noremap = true,
            silent = true,
        })
    end,
}

local ta = Terminal:new {
    direction = "float",
    close_on_exit = true,
}

local tb = Terminal:new {
    direction = "vertical",
    close_on_exit = true,
}

local tc = Terminal:new {
    direction = "horizontal",
    close_on_exit = true,
}

local toggleA = function(cmd)
    if ta:is_open() then
        ta:close()
        return
    end
    ta:open()
    tb:close()
    tc:close()

    if cmd ~= nil then
        ta:send(cmd)
    end
end

local toggleB = function()
    if tb:is_open() then
        tb:close()
        return
    end
    ta:close()
    tb:open()
    tc:close()
end

local toggleC = function()
    if tc:is_open() then
        tc:close()
        return
    end
    ta:close()
    tb:close()
    tc:open()
end

local toggleG = function()
    lazygit:toggle()
end

local set_group_hint = require('keybindings').SetGroupHint

map('n', "<leader>ta", toggleA, {}, 'Float')
map('n', "<leader>tb", toggleB, {}, 'Vertical')
map('n', "<leader>tc", toggleC, {}, 'Horizontal')
map('n', "<leader>tg", toggleG, {}, 'Lazygit')
map('t', "<leader>ta", toggleA, {}, 'Float')
map('t', "<leader>tb", toggleB, {}, 'Vertical')
map('t', "<leader>tc", toggleC, {}, 'Horizontal')
map('t', "<leader>tg", toggleG, {}, 'Lazygit')
set_group_hint('<leader>t', '+ ToggleTerm')
