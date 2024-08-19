---@class MochiUtil.cmp
local M = {}

---@return boolean
function M.visible()
    ---@module 'cmp'
    local cmp = package.loaded['cmp']
    return cmp and cmp.core.view:visible()
end

function M.setup()
    -- TODO: util.cmp setup
end

return M
