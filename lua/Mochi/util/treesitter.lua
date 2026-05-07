---@class MochiUtil.treesitter
local M = {}

-- incremental selection
local selections = {} -- buf -> TSNode[]

local function get_vim_range(node, buf)
    local srow, scol, erow, ecol = node:range()
    srow = srow + 1
    scol = scol + 1
    erow = erow + 1

    if ecol == 0 then
        erow = erow - 1
        if not buf or buf == 0 then
            ecol = vim.fn.col({ erow, '$' }) - 1
        else
            ecol = #vim.api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1]
        end
        ecol = math.max(ecol, 1)
    end
    return srow, scol, erow, ecol
end

-- update the selection range
local function update_selection(buf, node)
    local start_row, start_col, end_row, end_col = get_vim_range(node, buf)
    local mode = vim.api.nvim_get_mode().mode
    if mode ~= 'v' then vim.cmd('normal! v') end
    vim.api.nvim_win_set_cursor(0, { start_row, start_col - 1 })
    vim.cmd('normal! o')
    vim.api.nvim_win_set_cursor(0, { end_row, end_col - 1 })
end

-- initialize the selection, called in `normal` mode
function M.init_selection()
    local buf = vim.api.nvim_get_current_buf()
    vim.treesitter.get_parser(buf):parse()
    local node = vim.treesitter.get_node({ ignore_injections = false })
    if not node then return end
    selections[buf] = { node }
    update_selection(buf, node)
end

local function visual_selection_range()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos('v'))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos('.'))
    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
        return csrow, cscol, cerow, cecol
    else
        return cerow, cecol, csrow, cscol
    end
end

local function range_matches(node)
    local _, csrow, cscol, _ = unpack(vim.fn.getpos('v'))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos('.'))
    local srow, scol, erow, ecol = get_vim_range(node)
    return srow == csrow and scol == cscol and erow == cerow and ecol == cecol
end

-- find the smallest named node that covers the specified range
local function named_node_for_range(buf, sr, sc, er, ec)
    -- treesitter range: 0-indexed, end exclusive
    local node = vim.treesitter.get_node({
        buf = buf,
        pos = { sr - 1, sc - 1 }, -- convert to 0-indexed
        ignore_injections = false,
    })
    if not node then return nil end
    -- find upwards the first node with a different parent
    while node do
        local nr, nc, ner, nec = node:range()
        local nsr, nsc, ner2, nec2 = nr + 1, nc + 1, ner + 1, nec
        if nsr <= sr and nsc <= sc and ner2 >= er and nec2 >= ec then break end
        node = node:parent()
    end
    return node
end

local function vim_range_of_node(node)
    local sr, sc, er, ec = node:range()
    -- treesitter: 0-indexed, end exclusive
    -- vim getpos: 1-indexed, end inclusive
    return sr + 1, sc + 1, er + 1, ec
end

-- increment the selection, called in `visual` mode
function M.node_incremental()
    local buf = vim.api.nvim_get_current_buf()
    local nodes = selections[buf]
    local csrow, cscol, cerow, cecol = visual_selection_range()

    -- if stack is empty or the selection range doesn't match the top of the stack, initialize a new selection
    if not nodes or #nodes == 0 or not range_matches(nodes[#nodes]) then
        vim.treesitter.get_parser(buf):parse()
        local node = named_node_for_range(buf, csrow, cscol, cerow, cecol)
        if not node then return end
        update_selection(buf, node)
        if nodes and #nodes > 0 then
            table.insert(selections[buf], node)
        else
            selections[buf] = { node }
        end
        return
    end

    -- find upwards the first node with a different parent
    local node = nodes[#nodes]
    while true do
        local parent = node:parent()
        if not parent or parent == node then return end
        node = parent
        local srow, scol, erow, ecol = vim_range_of_node(node)
        local same = (srow == csrow and scol == cscol and erow == cerow and ecol == cecol)
        if not same then
            table.insert(selections[buf], node)
            update_selection(buf, node)
            return
        end
    end
end

-- decrement the selection, called in `visual` mode
function M.node_decremental()
    local buf = vim.api.nvim_get_current_buf()
    local nodes = selections[buf]

    if not nodes or #nodes < 2 then
        -- if the selection is empty, exit visual mode
        vim.cmd('normal! \27') -- <Esc>
        return
    end

    table.remove(selections[buf])
    update_selection(buf, nodes[#nodes])
end

---@param query_strings string|string[]
---@param query_group string
function M.goto_next_start(query_strings, query_group)
    if Util.plugin.has('nvim-treesitter-textobjects') then
        require('nvim-treesitter-textobjects.move').goto_next_start(query_strings, query_group)
    end
end

---@param query_strings string|string[]
---@param query_group string
function M.goto_next_end(query_strings, query_group)
    if Util.plugin.has('nvim-treesitter-textobjects') then
        require('nvim-treesitter-textobjects.move').goto_next_end(query_strings, query_group)
    end
end

---@param query_strings string|string[]
---@param query_group string
function M.goto_previous_start(query_strings, query_group)
    if Util.plugin.has('nvim-treesitter-textobjects') then
        require('nvim-treesitter-textobjects.move').goto_previous_start(query_strings, query_group)
    end
end

---@param query_strings string|string[]
---@param query_group string
function M.goto_previous_end(query_strings, query_group)
    if Util.plugin.has('nvim-treesitter-textobjects') then
        require('nvim-treesitter-textobjects.move').goto_previous_end(query_strings, query_group)
    end
end

return M
