return {
    -- auto completion
    {
        'saghen/blink.cmp',
        version = '*',
        opts_extend = {
            'sources.completion.enabled_providers',
            'sources.compat',
            'sources.default',
        },
        dependencies = {
            'rafamadriz/friendly-snippets',

            -- add blink.compat to dependencies
            {
                'saghen/blink.compat',
                version = '*',
                lazy = true,
                opts = {},
            },

            -- emoji
            'moyiz/blink-emoji.nvim',

            -- nerdfont
            'MahanRahmati/blink-nerdfont.nvim',
        },
        event = 'InsertEnter',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = {
                expand = function(snippet, _) return Util.cmp.expand(snippet) end,
            },

            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = 'mono',
            },

            completion = {
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { 'lsp' },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                ghost_text = {
                    enabled = vim.g.ai_cmp,
                },
            },

            signature = { enabled = true },

            sources = {
                compat = {},
                default = { 'lsp', 'path', 'snippets', 'buffer', 'nerdfont', 'emoji' },
                providers = {
                    emoji = {
                        module = 'blink-emoji',
                        name = 'Emoji',
                        score_offset = 15,
                        opts = { insert = true }, -- insert emoji (default) or complete its name
                    },
                    nerdfont = {
                        module = 'blink-nerdfont',
                        name = 'Nerd Fonts',
                        score_offset = 15,
                        opts = { insert = true }, -- insert nerdfont (default) or complete its name
                    },
                },
            },

            cmdline = { enabled = true },

            keymap = {
                preset = 'none',

                ['<CR>'] = { 'accept', 'fallback' },

                -- ['<Tab>'] -- setting in config
                ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

                -- select item
                ['<C-k>'] = { 'select_prev', 'fallback' },
                ['<C-j>'] = { 'select_next', 'fallback' },
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },

                -- show completion menu
                ['<A-,>'] = { 'show', 'fallback' },

                -- documentation
                ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
            },
        },

        ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
        config = function(_, opts)
            -- setup compat sources
            local enabled = opts.sources.default
            for _, source in ipairs(opts.sources.compat or {}) do
                opts.sources.providers[source] = vim.tbl_deep_extend(
                    'force',
                    { name = source, module = 'blink.compat.source' },
                    opts.sources.providers[source] or {}
                )
                if type(enabled) == 'table' and not vim.tbl_contains(enabled, source) then
                    table.insert(enabled, source)
                end
            end

            -- add ai_accept to <Tab> key
            if not opts.keymap['<Tab>'] then
                opts.keymap['<Tab>'] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    Util.cmp.map({ 'snippet_forward', 'ai_accept' }),
                    'fallback',
                }
            end

            -- Unset custom prop to pass blink.cmp validation
            opts.sources.compat = nil

            -- check if we need to override symbol kinds
            for _, provider in pairs(opts.sources.providers or {}) do
                ---@cast provider blink.cmp.SourceProviderConfig | { kind?: string }
                if provider.kind then
                    local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
                    local kind_idx = #CompletionItemKind + 1

                    CompletionItemKind[kind_idx] = provider.kind
                    ---@diagnostic disable-next-line: no-unknown
                    CompletionItemKind[provider.kind] = kind_idx

                    ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
                    local transform_items = provider.transform_items
                    ---@param ctx blink.cmp.Context
                    ---@param items blink.cmp.CompletionItem[]
                    provider.transform_items = function(ctx, items)
                        items = transform_items and transform_items(ctx, items) or items
                        for _, item in ipairs(items) do
                            item.kind = kind_idx or item.kind
                            item.kind_icon = Util.icon.kinds[item.kind_name] or item.kind_icon or nil
                        end
                        return items
                    end
                end

                -- unset custom prop to pass blink.cmp validation
                provider.kind = nil
            end

            require('blink.cmp').setup(opts)
        end,
    },

    -- add icons
    {
        'saghen/blink.cmp',
        opts = function(_, opts)
            opts.appearance = opts.appearance or {}
            opts.appearance.kind_icons = vim.tbl_extend('force', opts.appearance.kind_icons or {}, Util.icon.kinds)
        end,
    },
}
