local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = require('ascii').art.text.neovim.sharp

if vim.fn.has "win32" ~= 1 then
    dashboard.section.terminal.command = "cat | lolcat --seed=24 "
    .. os.getenv("HOME")
    .. "/.config/nvim/static/neovim.cat"
end

-- Set menu
dashboard.section.buttons.val = {
    -- dashboard.button("l", "   Load session", "<cmd>lua require('persisted').load()<CR>"),
    dashboard.button("e", "  > New file" , "<cmd>ene<CR>"),
    dashboard.button("r", "  > Recent file"   , "<cmd>Telescope oldfiles<CR>"),
    dashboard.button("f", "  > Find file", "<cmd>Telescope find_files hidden=true path_display=smart<CR>"),
    dashboard.button("g", "  > Search file", "<cmd>Telescope live_grep path_display=smart<CR>"),
    dashboard.button("u", "  > Update plugins"   , "<cmd>PackerSync<CR>"),
    dashboard.button("s", "  > Settings" , "<cmd>e $MYVIMRC | :cd %:p:h | Neotree<CR>"),
    dashboard.button("q", "  > Quit NVIM", "<cmd>qa!<CR>"),
}

-- Footer
local function footer()
    -- local total_plugins = require('packer').stats().count
    local version = vim.version()
    local nvim_version_info = "  Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch

    -- return " " .. total_plugins .. " plugins" .. nvim_version_info

    local v = vim.version()
    local datetime = os.date " %d-%m-%Y   %H:%M:%S"
    local platform = vim.fn.has "win32" == 1 and "" or ""
    -- return string.format("󰂖 %d  %s %d.%d.%d  %s", plugins, platform, v.major, v.minor, v.patch, datetime)
    return string.format("%s %d.%d.%d  %s", platform, v.major, v.minor, v.patch, datetime)
end

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "AlphaFooter"

-- Layout
dashboard.config.layout = {
    { type = "padding", val = 2 },
    dashboard.section.header,
    -- dashboard.section.terminal,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 1 },
    dashboard.section.footer,
}
dashboard.config.opts.noautocmd = false

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])

return {
    config = dashboard.opts
}
