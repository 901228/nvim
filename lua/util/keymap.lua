---@class MochiUtil.keymap
---@overload fun(mode: keymap.mode | keymap.mode[], lhs: string, rhs: string | fun(), opts: vim.keymap.set.Opts, desc: string)
local M = setmetatable({}, {
    __call = function(m, ...)
        m.keymap(...)
    end
})

M.keymappings = {}

---@alias keymap.mode
---| 'n' # normal
---| 'v' # visual & select
---| 's' # select
---| 'x' # visual
---| 'o' # operator-pending
---| 'i' # insert
---| 'l' # insert & command-line & lang-args
---| 'c' # command-line
---| 't' # terminal

---@param mode keymap.mode | keymap.mode[]
---@param lhs string keymap
---@param rhs string | fun() mapping command or function
---@param opts? vim.keymap.set.Opts
---@param desc? string description of this keymap
function M.keymap(mode, lhs, rhs, opts, desc)
    if desc == nil then
        if type(rhs) == 'string' then
            desc = rhs
        else
            desc = ''
        end
    end

    opts = opts or { noremap = true, silent = true }
    M.keymappings[lhs] = vim.tbl_extend('force',
        {
            rhs,
            desc = desc,
            mode = mode,
        },
        opts
    )

    opts = vim.tbl_extend('force',
        {
            lhs,
            rhs,
            desc = desc,
            mode = mode,
        },
        opts
    )

    local has_wk, wk = pcall(require, 'which-key')

    if has_wk then
        wk.add(opts)
    else
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

---@param prefix string prefix(keymap) of this group
---@param name string name of this group
function M.key_group(prefix, name)
    local has_wk, wk = pcall(require, 'which-key')
    if not has_wk then
        return
    else
        M.keymappings[prefix] = name
        wk.add({ prefix, group = name })
    end
end

return M
