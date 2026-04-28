return {
    { 'nvzone/volt', lazy = true },
    { 'nvzone/minty', cmd = { 'Shades', 'Huefy' } },
    {
        'nvzone/menu',
        lazy = true,
        dependencies = 'nvzone/minty',
        keys = {
            {
                '<C-t>',
                function() require('menu').open('default') end,
                desc = 'Open menu',
                mode = { 'n', 'v' },
            },
            {
                '<RightMouse>',
                function()
                    require('menu.utils').delete_old_menus()

                    vim.cmd('aunmenu PopUp')
                    vim.cmd.exec('"normal! \\<RightMouse>"')

                    -- clicked buf
                    local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
                    local options = vim.bo[buf].ft == 'neo-tree' and 'neo-tree' or Util.menus.default

                    require('menu').open(options, { mouse = true })
                end,
                desc = 'Open menu',
                mode = { 'n', 'v' },
            },
        },
    },
}
