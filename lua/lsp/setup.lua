local status, mason = pcall(require, 'mason')
if not status then
    vim.notify("missing mason")
    return
end

local status, mason_config = pcall(require, 'mason-lspconfig')
if not status then
    vim.notify("missing mason-lspconfig")
    return
end

require('neodev').setup({})

local status, lspconfig = pcall(require, 'lspconfig')
if not status then
    vim.notify("missing lspconfig")
    return
end

-- local status, lspconfig_util = pcall(require, 'lspconfig.util')
-- if not status then
--     vim.notify("missing lspconfig.util")
--     return
-- end

mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

-- mason-lspconfig uses the `lspconfig` server names in the APIs it exposes - not `mason.nvim` package names
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
mason_config.setup({
    ensure_installed = {
        -- "jsonls",
        -- "lua_ls",
        -- 'bashls',
        -- 'clangd',
        -- 'cmake',
        -- 'html',
        -- -- 'jdtls',
        -- 'tsserver',
        -- "pyright",
        -- -- 'taplo',
        -- 'cssls'
    },
})

local servers = {
    jsonls = require('lsp.config.json'),
    lua_ls = require('lsp.config.lua'),
    pyright = require('lsp.config.pyright'),
    clangd = require('lsp.config.clangd'),
    cmake = require('lsp.config.cmake'),
    dockerls = require('lsp.config.dockerls'),
    lemminx = require('lsp.config.lemminx'),
    vala_ls = require('lsp.config.vala'),
    css_ls = require('lsp.config.css'),
    -- rust_analyzer = require('lsp.config.rust'),
}

for name, config in pairs(servers) do
    if config ~= nil and type(config) == "table" then
        -- if the config is in the table
        config.on_setup(lspconfig[name])
    else
        -- default
        lspconfig[name].setup({})
    end
end

require('lsp.ui').setup()

-- rustacean
require('lsp.config.rust')

-- local lsp_defaults = lspconfig.util.default_config
--
-- lsp_defaults.capabilities = vim.tbl_deep_extend(
--   'force',
--   lsp_defaults.capabilities,
--   require('cmp_nvim_lsp').default_capabilities()
-- )

