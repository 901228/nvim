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

---@class MochiKeySpec: MochiKeyOpts
---@field [1] keymap.mode | keymap.mode[] mode
---@field [2] string lhs
---@field [3] string | fun()  rhs
---@field [4]? string desc

---@class MochiKey
---@field mode keymap.mode | keymap.mode[]
---@field lhs string
---@field rhs string | fun()
---@field opts? MochiKeyOpts
---@field desc? string

---@class MochiKeyGroupSpec: MochiKeyOpts
---@field [1] string lhs
---@field [2] string name
---@field [3]? MochiKeySpec[] keys

---@class MochiKeyGroup
---@field lhs string
---@field name string
---@field opts? MochiKeyOpts
---@field keys? MochiKey[]

---@param key MochiKeyGroupSpec | MochiKeySpec
---@return boolean
function M.is_groupSpec(key)
    return type(key[3]) ~= 'string' and type(key[3]) ~= 'function'
end

---@param key MochiKeyGroup | MochiKey
---@return boolean
function M.is_group(key)
    return key.name ~= nil
end

---@param key? MochiKeySpec
---@return MochiKey
local function parse_key(key)
    key = key or {}
    local mode = table.remove(key, 1)
    local lhs = table.remove(key, 1)
    local rhs = table.remove(key, 1)
    local desc = table.remove(key, 1)
    return {
        mode = mode,
        lhs = lhs,
        rhs = rhs,
        desc = desc,
        opts = key,
    }
end

---@param keys? MochiKeySpec[]
---@param prefix? string
---@param opts? MochiKeyOpts
---@return MochiKey[]
local function parse_keys(keys, prefix, opts)
    keys = keys or {}
    local ret = {}

    for _, k in ipairs(keys) do
        local key = parse_key(k)
        local icon = key.opts.icon
        key.lhs = prefix .. key.lhs
        key.opts = vim.tbl_extend('force', opts, key.opts)
        key.opts.icon = icon

        ret[#ret + 1] = key
    end

    return ret
end

---@param keys? (MochiKeyGroupSpec | MochiKeySpec)[]
---@return (MochiKeyGroup | MochiKey)[]
function M.parse(keys)
    local ret = {} ---@type (MochiKeyGroup | MochiKey)[]

    keys = keys or {}
    for _, key in ipairs(keys) do
        if M.is_groupSpec(key) then
            ---@cast key MochiKeyGroupSpec
            local prefix = table.remove(key, 1)
            local name = table.remove(key, 1)
            local group_keys = table.remove(key, 1)
            local opts = key
            ret[#ret + 1] = {
                lhs = prefix,
                name = name,
                opts = opts,
                keys = parse_keys(group_keys, prefix, opts),
            }
        else
            ---@cast key MochiKeySpec
            ret[#ret + 1] = parse_key(key)
        end
    end

    return ret
end

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

    opts = opts or { noremap = true, silent = true }
    if lhs == nil then
        -- FIXME: trace
        Util.pretty_trace()
        Util.notify('FAQ')
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

    if has_wk then
        wk.add(opts)
    else
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

---@param lhs string prefix(keymap) of this group
---@param name string name of this group
---@param opts? MochiKeyOpts
function M.key_group(lhs, name, opts)
    local has_wk, wk = pcall(require, 'which-key')
    if not has_wk then
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
