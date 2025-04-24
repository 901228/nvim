---@class MochiUtil.ui
local M = {}

---@param buf? number
function M.bufremove(buf)
    buf = buf or 0
    buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

    if vim.bo.modified then
        local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
        if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
            return
        end
        if choice == 1 then -- Yes
            vim.cmd.write()
        end
    end

    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_call(win, function()
            if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end
            -- Try using alternate buffer
            local alt = vim.fn.bufnr('#')
            if alt ~= buf and vim.fn.buflisted(alt) == 1 then
                vim.api.nvim_win_set_buf(win, alt)
                return
            end

            -- Try using previous buffer
            local has_previous = vim.cmd('bprevious')
            if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then return end

            -- Create new listed buffer
            local new_buf = vim.api.nvim_create_buf(true, false)
            vim.api.nvim_win_set_buf(win, new_buf)
        end)
    end
    if vim.api.nvim_buf_is_valid(buf) then vim.cmd('bdelete! ' .. buf) end
end

M.lualine = {}

---@param icon string
---@param status fun(): nil | 'ok' | 'error' | 'pending'
function M.lualine.status(icon, status)
    local colors = {
        ok = 'Special',
        error = 'DiagnosticError',
        pending = 'DiagnosticWarn',
    }
    local ret = status()
    return {
        function() return icon end,
        cond = function() return ret ~= nil end,
        color = function() return { fg = Util.color.get_color_from_group(colors[ret or 'ok']) } end,
    }
end

---@param name string
---@param icon? string
function M.lualine.cmp_source(name, icon)
    icon = icon or Util.icon.kinds[name:sub(1, 1):upper() .. name:sub(2)]
    local started = false
    return M.lualine.status(icon, function()
        if not package.loaded['cmp'] then return end
        for _, s in ipairs(require('cmp').core.sources or {}) do
            if s.name == name then
                if s.source:is_available() then
                    started = true
                else
                    return started and 'error' or nil
                end
                if s.status == s.SourceStatus.FETCHING then return 'pending' end
                return 'ok'
            end
        end
    end)
end

return M
