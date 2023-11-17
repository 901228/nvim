vim.cmd [[packadd nvim-tree.lua]]

vim.g.nvim_tree_side = "left"
vim.g.nvim_tree_width = 25
vim.g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
vim.g.nvim_tree_auto_open = true
vim.g.nvim_tree_auto_close = true
vim.g.nvim_tree_quit_on_open = 0
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_root_folder_modifier = ":~"
vim.g.nvim_tree_tab_open = 1
vim.g.nvim_tree_allow_resize = 1

vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1
}

vim.g.nvim_tree_icons = {
    default = " ",
    symlink = " ",
    git = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★"
    },
    folder = {
        default = "",
        open = "",
        symlink = ""
    }
}

local get_lua_cb = function(cb_name)
    return string.format(":lua require'nvim-tree'.on_keypress('%s')<CR>", cb_name)
end


vim.g.nvim_tree_bindings = {
    ["<CR>"] = get_lua_cb("edit"),
    ["o"] = get_lua_cb("edit"),
    ["<2-LeftMouse>"] = get_lua_cb("edit"),
    ["<2-RightMouse>"] = get_lua_cb("cd"),
    ["<C-]>"] = get_lua_cb("cd"),
    ["<C-v>"] = get_lua_cb("vsplit"),
    ["<C-x>"] = get_lua_cb("split"),
    ["<C-t>"] = get_lua_cb("tabnew"),
    ["<BS>"] = get_lua_cb("close_node"),
    ["<S-CR>"] = get_lua_cb("close_node"),
    ["<Tab>"] = get_lua_cb("preview"),
    ["I"] = get_lua_cb("toggle_ignored"),
    ["H"] = get_lua_cb("toggle_dotfiles"),
    ["R"] = get_lua_cb("refresh"),
    ["a"] = get_lua_cb("create"),
    ["d"] = get_lua_cb("remove"),
    ["r"] = get_lua_cb("rename"),
    ["<C-r>"] = get_lua_cb("full_rename"),
    ["x"] = get_lua_cb("cut"),
    ["c"] = get_lua_cb("copy"),
    ["p"] = get_lua_cb("paste"),
    ["[c"] = get_lua_cb("prev_git_item"),
    ["]c"] = get_lua_cb("next_git_item"),
    ["-"] = get_lua_cb("dir_up"),
    ["q"] = get_lua_cb("close")
}

require('nvim-tree').setup {}

local open_nvim_tree = function(data)

    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1

    -- buffer is a [No Name]
    local no_name = data.file == '' and vim.bo[data.buf].buftype == ''

    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not real_file and not no_name and not directory then
        return
    elseif not directory then
        return
    elseif directory then -- change to the directory
        vim.cmd.cd(data.file)
        -- require('alpha').start(true, require('plugin-config.alpha').config)
        return
    end

    -- open the tree but don't focus it
    require('nvim-tree.api').tree.toggle({ focus = false })
end

-- auto open when enter nvim
vim.api.nvim_create_autocmd('VimEnter', { callback = open_nvim_tree })

-- auto close when leave nvim
vim.api.nvim_create_autocmd('BufEnter', {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd('quit')
    end
  end
})
