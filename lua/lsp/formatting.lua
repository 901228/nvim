require('conform').setup({
    formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        ['*'] = { 'codespell' },
        ['_'] = { 'trim_whitespace' },
    },
    default_format_opts = {
        async = true,
        lsp_format = 'fallback',
    },
    format_on_save = nil,
    format_after_save = nil,
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
    notify_no_formatters = true,
    formatters = {
        rustfmt = {
            command = 'rustfmt',
        },
    },
})
