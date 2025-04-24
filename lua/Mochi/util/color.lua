---@class MochiUtil.color
local M = {}

-- sapphire -> sky
--    crust -> black0
--   mantle -> black1
--     base -> black2
-- surface0 -> black3
-- surface1 -> black4
-- surface2 -> gray0
-- overlay0 -> gray1
-- overlay1 -> gray2
-- overlay2 -> gray2
--     text -> white
-- subtext0 -> white
-- subtext1 -> white

---@type CtpColors<string>
M.latte = {
    -- rosewater = '',
    -- flamingo = '',
    -- pink = '',
    -- mauve = '',
    -- red = '',
    -- maroon = '',
    -- peach = '',
    -- yellow = '',
    -- green = '',
    -- teal = '',
    -- sky = '',
    -- sapphire = '',
    -- blue = '',
    -- lavender = '',
    -- text = '',
    -- subtext1 = '',
    -- subtext0 = '',
    -- overlay2 = '',
    -- overlay1 = '',
    -- overlay0 = '',
    -- surface2 = '',
    -- surface1 = '',
    -- surface0 = '',
    -- base = '',
    -- mantle = '',
    -- crust = '',
    -- none = '',
}

---@type CtpColors<string>
M.frappe = {
    -- rosewater = '',
    -- flamingo = '',
    -- pink = '',
    -- mauve = '',
    -- red = '',
    -- maroon = '',
    -- peach = '',
    -- yellow = '',
    -- green = '',
    -- teal = '',
    -- sky = '',
    -- sapphire = '',
    -- blue = '',
    -- lavender = '',
    -- text = '',
    -- subtext1 = '',
    -- subtext0 = '',
    -- overlay2 = '',
    -- overlay1 = '',
    -- overlay0 = '',
    -- surface2 = '',
    -- surface1 = '',
    -- surface0 = '',
    -- base = '',
    -- mantle = '',
    -- crust = '',
    -- none = '',
}

---@type CtpColors<string>
M.macchiato = {
    -- rosewater = '',
    -- flamingo = '',
    -- pink = '',
    -- mauve = '',
    -- red = '',
    -- maroon = '',
    -- peach = '',
    -- yellow = '',
    -- green = '',
    -- teal = '',
    -- sky = '',
    -- sapphire = '',
    -- blue = '',
    -- lavender = '',
    -- text = '',
    -- subtext1 = '',
    -- subtext0 = '',
    -- overlay2 = '',
    -- overlay1 = '',
    -- overlay0 = '',
    -- surface2 = '',
    -- surface1 = '',
    -- surface0 = '',
    -- base = '',
    -- mantle = '',
    -- crust = '',
    -- none = '',
}

---@type CtpColors<string>
M.mocha = {
    -- rosewater = '',
    -- flamingo = '',
    -- pink = '',
    -- mauve = '',
    -- red = '',
    -- maroon = '',
    -- peach = '',
    -- yellow = '',
    -- green = '',
    -- teal = '',
    -- sky = '',
    -- sapphire = '',
    -- blue = '',
    -- lavender = '',
    -- text = '',
    -- subtext1 = '',
    -- subtext0 = '',
    -- overlay2 = '',
    -- overlay1 = '',
    -- overlay0 = '',
    -- surface2 = '',
    -- surface1 = '',
    -- surface0 = '',
    -- base = '',
    -- mantle = '',
    -- crust = '',
    -- none = '',
}

---@param group string | string[] hl group to get color from
---@param prop? string property to get. Defauls to `fg`
function M.get_color_from_group(group, prop)
    prop = prop or 'fg'
    group = type(group) == 'table' and group or { group }
    ---@cast group string[]
    for _, g in ipairs(group) do
        local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
        if hl[prop] then return string.format('#%06x', hl[prop]) end
    end
end

return M
