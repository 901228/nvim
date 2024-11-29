return {
    {
        -- formatting
        'stevearc/conform.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        lazy = true,
        cmd = 'ConformInfo',
        init = function()
            -- install conform formatters on VeryLazy
            Util.plugin.on_very_lazy(function()
                Util.format.register({
                    name = 'conform.nvim',
                    priority = 100,
                    primary = true,
                    format = function(bufnr) require('conform').format({ bufnr = bufnr }) end,
                    sources = function(bufnr)
                        local ret = require('conform').list_formatters(bufnr)
                        ---@param v conform.FormatterInfo
                        return vim.tbl_map(function(v) return v.name end, ret)
                    end,
                })
            end)
        end,
        opts = {
            default_format_opts = {
                timeout_ms = 3000,
                async = false,
                quiet = false,
                lsp_format = 'fallback',
            },
            formatters_by_ft = {
                lua = { 'stylua' },
                sh = { 'shfmt' },
                rust = { 'rustfmt' },
                python = { 'black', 'isort' },
                ['*'] = { 'codespell' },
                ['_'] = { 'trim_whitespace' },
            },
            ---@type table<string, conform.FormatterConfigOverride | fun(bufnr: integer): (nil | conform.FormatterConfigOverride)>
            formatters = {
                -- formatter settings
                injected = { options = { ignore_errors = true } },
                rustfmt = {
                    command = 'rustfmt',
                },
                black = {
                    prepend_args = {
                        '--line-length=140',
                    },
                },
                isort = {
                    prepend_args = { '--profile', 'black' },
                },
            },
            format_on_save = nil,
            format_after_save = nil,
            notify_on_error = true,
            notify_no_formatters = true,
            log_level = vim.log.levels.ERROR,
        },
    },
}
