local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup {
    -- snippet engine
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },

    -- soureces

    sources = cmp.config.sources({
        {
            name = "luasnip",
            group_index = 1,
        },
        {
            name = "nvim_lsp",
            group_index = 1,
        },
        {
            name = "nvim_lsp_signature_help",
            group_index = 1,
        },
        {
            name = "buffer",
            group_index = 2,
        },
        {
            name = "path",
            group_index = 2,
        },
    }),

    -- shortcut
    mapping = require('keybindings').cmp(cmp),

    -- view
    view = {
        entries = {
            name = 'custom',
            -- selection_order = 'near_cursor'
        }
    },

    -- windows
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    -- use lspkind-nvim to show icons
    formatting = {
        format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            before = function (entry, vim_item)
                vim_item.menu = " <"..string.upper(entry.source.name)..">"
                return vim_item
            end
        })
    },
}

-- use buffer source for '/' and '?'
cmp.setup.cmdline({ '/', '?' }, {
    sources = {
        { name = 'buffer' }
    }
})

-- use cmdline & path source for ':'
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
            { name = 'cmdline' }
        })
})
