return {
    {
        -- notification system of nvim
        'rcarriga/nvim-notify',
        opts = {
            stages = 'slide',
            timeout = 1000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
        init = function()
            if not Util.plugin.has('noice.nvim') then
                Util.plugin.on_very_lazy(function()
                    vim.notify = require('notify')
                end)
            end
        end,
    },
}
