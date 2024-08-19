---@class MochiUtil.path
local M = {}

---@alias MochiRootFn fun(buf: number): (string | string[])

---@alias MochiRootSpec string | string[] | MochiRootFn

---@class MochiRoot
---@field paths string[]
---@field spec MochiRootSpec

M.spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

---@param buf? integer
---@return string?
function M.bufpath(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf --[[@as integer]]
    return M.realpath(vim.api.nvim_buf_get_name(buf))
end

---@return string
function M.cwd()
    return M.realpath(vim.uv.cwd()) or ''
end

---@param path string
function M.norm(path)
    if path:sub(1, 1) == '~' then
        local home = vim.uv.os_homedir()
        if home ~= nil then
            if home:sub(-1) == '\\' or home:sub(-1) == '/' then
                home = home:sub(1, -2)
            end
            path = home .. path:sub(2)
        end
    end
    path = path:gsub('\\', '/'):gsub('/+', '/')
    return path:sub(-1) == '/' and path:sub(1, -2) or path
end

---@param path? string
---@return string?
function M.realpath(path)
    if path == '' or path == nil then
        return nil
    end

    path = vim.uv.fs_realpath(path) or path
    return M.norm(path)
end

---@param path string
---@return string
function M.basename(path)
    path = path:gsub('//', '/'):gsub('\\', '/')
    local index = path:find('/[^/]*$')
    if index ~= nil then index = index + 1 end

    local name = path:sub(index or 0)
    return name
end

---@alias FileCallback fun(path: string, name: string, type?: uv.aliases.fs_stat_types): boolean?

---@param path string
---@param fn? FileCallback
function M.ls(path, fn)
    local items = {}
    local handle = vim.uv.fs_scandir(path)
    while handle do
        local name, t = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end

        local fullpath = path .. '/' .. name
        local filetype = t or vim.uv.fs_stat(fullpath).type

        if fn ~= nil and fn(fullpath, name, filetype) == false then
            break
        end

        table.insert(items, {
            path = fullpath,
            name = name,
            filetype = filetype,
        })
    end

    return items
end

---@param path string
---@param fn FileCallback
function M.walk(path, fn)
    M.ls(path, function(child, name, type)
        if type == 'directory' then
            M.walk(child, fn)
        end

        fn(child, name, type)
    end)
end

---@param path string
---@param fn fun(mod: string)
function M.lsmod(path, fn)
    M.ls(path:gsub('%.', '/'), function(child, name, type)
        if ( type ~= 'directory' and name ~= 'init.lua' )
            or ( type == 'directory' and Util.find_item(M.ls(child), function(file) return file.name == 'init.lua' end) ~= nil ) then
            fn(child:gsub('/', '.'):gsub('^lua%.', ''):gsub('%.lua$', ''))
        end
    end)
end

M.detectors = {}

---@return string[]
function M.detectors.cwd()
    return { vim.uv.cwd() }
end

---@param buf? number
---@return string[]
function M.detectors.lsp(buf)
    local bufpath = M.bufpath(buf)
    if not bufpath then
        return {}
    end

    local roots = {} ---@type string[]
    for _, client in pairs(Util.lsp.get_clients({ bufnr = buf })) do
        local workspace = client.config.workspace_folders or {}
        for _, ws in pairs(workspace) do
            roots[#roots + 1] = vim.uri_to_fname(ws.uri)
        end
        if client.root_dir then
            roots[#roots + 1] = client.root_dir
        end
    end

    return vim.tbl_filter(function(path)
        path = M.norm(path)
        return path and bufpath:find(path, 1, true) == 1
    end, roots)
end

---@param buf? number
---@param patterns string | string[]
function M.detectors.pattern(buf, patterns)
    patterns = type(patterns) == 'string' and { patterns } or patterns --[[@as string[] ]]
    local path = M.bufpath(buf) or vim.uv.cwd()
    local pattern = vim.fs_find(function(name)
        for _, p in ipairs(patterns) do
            if name == p
                or p:sub(1, 1) == '*' and name:find(vim.pesc(p:sub(2)) .. '$') then
                return true
            end
        end
        return false
    end, { path = path, upward = true })[1]
    return pattern and { vim.fs.dirname(pattern) } or {}
end

---@param spec MochiRootSpec
---@return MochiRootFn
function M.resolve(spec)
    if M.detectors[spec] then
        return M.detectors[spec]
    elseif type(spec) == 'function' then
        return spec
    end

    return function(buf)
        return M.detectors.pattern(buf, spec)
    end
end

---@param opts? { buf?: number, spec?: MochiRootSpec[], all?: boolean }
function M.detect(opts)
    opts = opts or {}
    opts.spec = opts.spec or M.spec
    opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

    local ret = {} ---@type MochiRoot[]
    for _, spec in ipairs(opts.spec) do
        local paths = M.resolve(spec)(opts.buf)
        paths = paths or {}
        paths = type(paths) == 'string' and { paths } or paths --[[@as string[] ]]

        local roots = {} ---@type string[]
        for _, p in ipairs(paths) do
            local pp = M.realpath(p)
            if pp and not vim.tbl_contains(roots, pp) then
                roots[#roots + 1] = pp
            end
        end

        table.sort(roots, function(a, b) return #a > #b end)

        if #roots > 0 then
            ret[#ret + 1] = { spec = spec, paths = roots }
            if opts.all == false then
                break
            end
        end
    end

    return ret
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {normalize?:boolean, buf?:number}
---@return string
function M.root(opts)
    opts = opts or {}
    local buf = opts.buf or vim.api.nvim_get_current_buf()
    local roots = M.detect({ all = false, buf = buf })
    local ret = roots[1] and roots[1].paths[1] or vim.uv.cwd() or '.'

    if opts and opts.normalize then
        return ret
    end
    return Util.os.is_win() and ret:gsub("/", "\\") or ret or ''
end

return M
