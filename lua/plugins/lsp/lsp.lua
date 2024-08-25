local common = require('plugins.lsp.common')

return {
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        build = ':MasonUpdate',
        opts_extend = { 'ensure_installed' },
        ---@alias MasonOpts MasonSettings | { ensure_installed: string[] }
        ---@type MasonOpts
        opts = {
            ensure_installed = {
                'stylua',
                'shfmt',
            },
            ui = {
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        },
        ---@param opts MasonOpts
        config = function(_, opts)
            require('mason').setup(opts)
            local mr = require('mason-registry')
            mr:on('package:install:success', function()
                vim.defer_fn(function()
                    require('lazy.core.handler.event').trigger({
                        event = 'FileType',
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            mr.refresh(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end)
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function() end,
    },

    -- lsp
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'mason.nvim',
            'mason-lspconfig.nvim',
            'nvim-navic',
            'schemastore.nvim',
            'rustaceanvim',
            'clear-action.nvim',
            'nvim-cmp',
        },
        event = 'LazyFile',
        opts = {
            diagnostic = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = 'if_many',
                    prefix = 'icons',
                },
                severity_sort = true,
                signs = Util.diagnostic.icons,
                show_header = false,
                float = {
                    source = 'always',
                    border = 'rounded',
                    style = 'minimal',
                    header = '',
                },
            },
            inlay_hints = {
                enabled = true,
                exclude = {},
            },
            codelens = { enabled = true },
            document_highlight = { enabled = true },
            capabilities = {
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
            },
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
        },
        config = function(_, opts)
            -- setup auto format
            Util.format.register(Util.lsp.formatter())

            -- setup keymaps
            Util.lsp.on_attach(function(client, bufnr)
                common.key.attach(bufnr)
            end)

            -- setup lsp
            Util.lsp.setup()

            -- setup keymap dynamic capability
            Util.lsp.on_dynamic_capability(function(client, bufnr)
                common.key.on_attach(bufnr)
            end)

            -- setup words
            Util.lsp.words.setup(opts.document_highlight)

            ---- diagnostic ----
            if Util.is_version_10 then
                -- inlay hints
                if opts.inlay_hints.enabled then
                    Util.lsp.on_supports_method('textDocument/inlayHint', function(_, bufnr)
                        if vim.api.nvim_buf_is_valid(bufnr)
                            and vim.bo[bufnr].buftype == ''
                            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[bufnr].filetype)
                        then
                            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                        end
                    end)
                end

                -- code lens
                if opts.codelens.enabled and vim.lsp.codelens then
                    Util.lsp.on_supports_method('textDocument/codeLens', function(_, bufnr)
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                            buffer = bufnr,
                            callback = vim.lsp.codelens.refresh,
                        })
                    end)
                end
            end

            -- virtual text
            if type(opts.diagnostic.virtual_text) == 'table' and opts.diagnostic.virtual_text.prefix == 'icons' then
                opts.diagnostic.virtual_text.prefix = (not Util.is_version_10) and '●'
                    or function(diagnostic)
                        for d, icon in pairs(Util.diagnostic.icons) do
                            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                                return icon
                            end
                        end
                    end
            end

            -- setup diagnostic config
            vim.diagnostic.config(vim.deepcopy(opts.diagnostic))
            Util.diagnostic.setup(opts.diagnostic.signs)

            ---- servers ----
            local servers = opts.servers

            -- capabilities
            local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend('force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                opts.capabilities or {}
            )

            -- mason
            local has_mason, mslp = pcall(require, 'mason-lspconfig')
            local all_mslp_servers = {}
            if has_mason then
                all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
            end

            -- ensure_installed
            local ensure_installed = {} ---@type string[]

            -- setup lsp servers
            ---@param server string
            local function setup(server)
                local server_opts = vim.tbl_deep_extend('force',
                    {
                        capabilities = vim.deepcopy(capabilities),
                        flags = common.flags,
                        on_attach = common.on_attach,
                    },
                    type(servers[server]) == 'table' and servers[server] or {}
                )

                if server_opts.enabled == false then
                    return
                end

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup['*'] then
                    if opts.setup['*'](server, server_opts) then
                        return
                    end
                end

                require('lspconfig')[server].setup(server_opts)
            end

            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    if server_opts.enabled ~= false then
                        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                            setup(server)
                        else
                            ensure_installed[#ensure_installed + 1] = server
                        end
                    end
                end
            end

            -- setup mason-lspconfig
            ensure_installed = vim.tbl_deep_extend('force',
                ensure_installed,
                Util.plugin.opts('mason-lspconfig.nvim').ensure_installed or {}
            )
            if has_mason then
                mslp.setup({
                    ensure_installed = ensure_installed,
                    handlers = { setup },
                })
            end

            -- check deno & vts
            if Util.lsp.is_enabled('denols') and Util.lsp.is_enabled('vtsls') then
                local is_deno = require('lspconfig.util').root_pattern('deno.json', 'deno,jsonc')
                Util.lsp.disable('vtsls', is_deno)
                Util.lsp.disable('denols', function(root_dir, config)
                    if not is_deno(root_dir) then
                        config.settings.deno.enable = false
                    end
                    return false
                end)
            end
        end,
    },
}
