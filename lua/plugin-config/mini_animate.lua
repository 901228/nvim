return function()
    -- don't use animate when scrolling with the mouse
    local mouse_scrolled = false
    for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
            mouse_scrolled = true
            return key
        end, { expr = true })
    end

    local animate = require('mini.animate')
    return {}
end
