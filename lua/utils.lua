local M = {}

M.colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    lighterGrey  = '#c6c6c6',
    whhite = '#ffffff',
    red    = '#ff5189',
    pink = '#d4bfff',
    violet = '#ee82ee',
    grey   = '#303030',
    lightBlue = '#59c2ff',
    transparent = nil,
    lightGrey = '#797979',
    yellow = '#FFFF00',
    green = '#bbe67e',
    coral = '#f07178',
    darkGrey = '#242b38',
}

M.find_item = function(item, arr)
    for _, v in pairs(arr) do
        if v == item then
            return true
        end
    end
    return false
end

--TODO: add OS detect functions
M.os = {
    is_windows = function ()
        return false
    end,
    is_linux = function()
     return true
    end,
}

return M
