---@class MochiUtil.keymap
---@overload fun(mode: keymap.mode | keymap.mode[], lhs: string, rhs: string | fun(), opts: MochiKeyOpts, desc: string)
local M = setmetatable({}, {
    __call = function(m, ...)
        m.keymap(...)
    end
})

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

---@class MochiKeyOpts
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean
---@field expr? boolean
---@field unique? boolean
---@field buffer? integer | boolean
---@field ft? string | string[]
---@field icon? wk.Icon | string | fun(): (wk.Icon | string)

M.keymappings = {}

---@param mode keymap.mode | keymap.mode[]
---@param lhs string keymap
---@param rhs string | fun() mapping command or function
---@param opts? MochiKeyOpts
---@param desc? string description of this keymap
function M.keymap(mode, lhs, rhs, opts, desc)
    if desc == nil then
        if type(rhs) == 'string' then
            desc = rhs
        else
            desc = ''
        end
    end

    opts = vim.tbl_extend('force', opts or {},{
        noremap = true,
        silent = true,
    })
    if lhs == nil then
        return
    end

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

    if has_wk and wk.add ~= nil then
        wk.add(opts)
    else
        opts[1] = nil
        opts[2] = nil
        opts.mode = nil
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

---@param lhs string prefix(keymap) of this group
---@param name string name of this group
---@param opts? MochiKeyOpts
function M.key_group(lhs, name, opts)
    local has_wk, wk = pcall(require, 'which-key')
    if not has_wk or wk.add == nil then
        return
    else
        M.keymappings[lhs] = name
        opts = opts or {}
        opts[1] = lhs
        ---@diagnostic disable-next-line
        opts.group = name
        wk.add(opts)
    end
end

return M
