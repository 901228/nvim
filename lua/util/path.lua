local M = {}
M.path = {}

---@param path string
---@return string
function M.path.basename(path)
    path = path:gsub('//', '/'):gsub('\\', '/')
    local index = path:find('/[^/]*$')
    if index ~= nil then index = index + 1 end

    local name = path:sub(index or 0)
    return name
end

---@alias FileType 'file'|'directory'|'link'
---@alias FileCallback function(path: string, name: string, type: FileType): boolean?
---@param path string
---@param fun FileCallback?
function M.path.ls(path, fun)
    local items = {}
    local handle = vim.uv.fs_scandir(path)
    while handle do
        local name, t = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end

        local fullpath = path .. '/' .. name
        local filetype = t or vim.uv.fs_stat(fullpath)

        if fun ~= nil and fun(fullpath, name, filetype) == false then
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
---@param fun FileCallback
function M.path.walk(path, fun)
    M.path.ls(path, function(child, name, type)
        if type == 'directory' then
            M.path.walk(child, fun)
        end

        fun(child, name, type)
    end)
end

---@param path string
---@param fun function(mod: string)
function M.path.lsmod(path, fun)
    M.path.ls(path:gsub('%.', '/'), function(child, name, type)
        if ( type ~= 'directory' and name ~= 'init.lua' )
            or ( type == 'directory' and Util.find_item(M.path.ls(child), function(file) return file.name == 'init.lua' end) ~= nil ) then
            fun(child:gsub('/', '.'):gsub('^lua%.', ''):gsub('%.lua$', ''))
        end
    end)
end

return M
