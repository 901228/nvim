return {
    -- popup terminals
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        opts = {
            size = function(term)
                if term.direction == 'horizontal' then
                    return 15
                elseif term.direction == 'vertical' then
                    return vim.o.columns * 0.3
                end
            end,
            shade_terminals = false,
            float_opts = {
                border = 'curved'
            },
            start_in_insert = true,
        },
        config = function(_, opts)
            require('toggleterm').setup(opts)

            local Terminal = require('toggleterm.terminal').Terminal
            local lazygit = Terminal:new({
                cmd = 'lazygit',
                dir = 'git_dir',
                direction = 'float',
                float_opts = {
                    border = 'double',
                },
                on_open = function(term)
                    vim.cmd('startinsert!')

                    -- q / <leader>tg close lazygit
                    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<CMD>close<CR>', { noremap = true, silent = true })
                    Util.keymap('n', '<leader>tg', '<CMD>close<CR>',
                        { noremap = true, silent = true, buffer = term.bufnr })

                    -- disable ESC for lazygit
                    if vim.fn.mapcheck('<Esc>', 't') ~= '' then
                        vim.api.nvim_del_keymap('t', '<Esc>')
                    end
                end,
                on_close = function()
                    -- add ESC back
                    vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
                end,
            })
            local ta = Terminal:new({
                direction = 'float',
                close_on_exit = true,
            })
            local tb = Terminal:new({
                direction = 'vertical',
                close_on_exit = true,
            })
            local tc = Terminal:new({
                direction = 'horizontal',
                close_on_exit = true,
            })
            local toggleT = function(term)
                if term:is_open() then
                    term:close()
                    return
                end
                ta:open()
            end
            local toggleG = function()
                lazygit:toggle()
            end

            Util.keymap.key_group('<leader>t', '+ ToggleTerm')
            Util.keymap({ 'n', 't' }, '<leader>ta', function() toggleT(ta) end, {}, 'Float')
            Util.keymap({ 'n', 't' }, '<leader>tb', function() toggleT(tb) end, {}, 'Vertical')
            Util.keymap({ 'n', 't' }, '<leader>tc', function() toggleT(tc) end, {}, 'Horizontal')
            Util.keymap({ 'n', 't' }, '<leader>tg', toggleG, {}, 'Lazygit')
        end,
    },
}
