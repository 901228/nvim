---@class MochiUtil.plugin
local M = {}

function M.setup() M.lazy_file() end

M.lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }
function M.lazy_file()
    vim.api.nvim_create_autocmd('BufReadPost', {
        once = true,
        callback = function(event)
            -- Skip if we already entered vim
            if vim.v.vim_did_enter == 1 then return end

            -- Try to guess the filetype (may change later on during Neovim startup)
            local ft = vim.filetype.match({ buf = event.buf })
            if ft then
                -- Add treesitter highlights and fallback to syntax
                local lang = vim.treesitter.language.get_lang(ft)
                if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then vim.bo[event.buf].syntax = ft end

                -- Trigger early redraw
                vim.cmd([[redraw]])
            end
        end,
    })

    M.register_LazyFile_event()
end

function M.register_LazyFile_event()
    -- Add support for the LazyFile event
    local Event = require('lazy.core.handler.event')

    Event.mappings.LazyFile = { id = 'LazyFile', event = M.lazy_file_events }
    Event.mappings['User LazyFile'] = Event.mappings.LazyFile
end

---@param fn fun()
function M.on_very_lazy(fn)
    vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function() fn() end,
    })
end

---@param name string
function M.get_plugin(name) return require('lazy.core.config').spec.plugins[name] end

---@param plugin string
---@return boolean
function M.has(plugin) return M.get_plugin(plugin) ~= nil end

---@param name string
function M.opts(name)
    local plugin = M.get_plugin(name)
    if not plugin then return {} end
    return require('lazy.core.plugin').values(plugin, 'opts', false)
end

---@param plugin string
function M.is_loaded(plugin)
    local Config = require('lazy.core.config')
    return Config.plugins[plugin] and Config.plugins[plugin]._.loaded
end

---@param name string
---@param fn fun(name: string)
function M.on_loaded(name, fn)
    if M.is_loaded(name) then
        fn(name)
    else
        vim.api.nvim_create_autocmd('User', {
            pattern = 'LazyLoad',
            callback = function(event)
                if event.data == name then
                    fn(name)
                    return true
                end
            end,
        })
    end
end

M.non_editor_ft = {
    'TelescopePrompt',
    'Trouble',
    'trouble',
    'help',
    'alpha',
    'neo-tree',
    'lazy',
    'mason',
    'notify',
    'toggleterm',
    'lspinfo',
}

return M
