return {
    -- auto completion
    {
        'hrsh7th/nvim-cmp',
        version = false,
        event = 'InsertEnter',
        dependencies = {
            -- buffer
            'hrsh7th/cmp-buffer', -- { name = 'buffer' },

            -- lsp
            'hrsh7th/cmp-nvim-lsp',                 -- { name = nvim_lsp }
            'hrsh7th/cmp-nvim-lsp-document-symbol', -- { name = nvim_lsp_document_symbol }
            'hrsh7th/cmp-nvim-lsp-signature-help',  -- { name = nvim_lsp_signature_help }

            -- paths
            'hrsh7th/cmp-path', -- { name = 'path' }

            -- command line
            'hrsh7th/cmp-cmdline', -- { name = 'cmdline' }

            -- icons, symbols, emojis
            'hrsh7th/cmp-emoji', -- { name = 'emoji' }

            'windwp/nvim-autopairs',
        },
        opts = function()
            vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })

            local cmp = require('cmp')
            local defaults = require('cmp.config.default')()
            local auto_select = true
            local enterBehavior = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
                else
                    fallback()
                end
            end

            return {
                auto_bracket = {
                    -- Not all LSP servers add brackets when completing a function
                    -- To better deal with it, add language here to configure
                },
                completion = {
                    completeopt = 'menu,menuone,noinsert' .. (auto_select and '' or ',noselect'),
                },
                preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    -- next candidated item
                    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
                    -- previous candidated item
                    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
                    -- show the completion list
                    ['<A-,>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    -- Accept currently selected item. If none selected, `select` first item.
                    -- Set `select` to `false` to only confirm explicitly selected items.
                    ['<CR>'] = cmp.mapping({
                        i = enterBehavior,
                        c = enterBehavior,
                        s = cmp.mapping.confirm({ select = true }),
                    }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                cmp.confirm()
                            end
                        else
                            fallback()
                        end
                    end, { 'i', 'c', 's' }),
                    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                }),
                sources = cmp.config.sources(
                    {
                        { name = 'nvim_lsp' },
                        { name = 'nvim_lsp_document_symbol' },
                        { name = 'nvim_lsp_signature_help' },
                        { name = 'path' },
                    },
                    {
                        { name = 'emoji' },
                        { name = 'buffer' },
                    }
                ),
                formatting = {
                    format = function(entry, item)
                        local icon = Util.icon.kinds
                        if icon[item.kind] then
                            item.kind = icon[item.kind] .. item.kind
                        end

                        local widths = {
                            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
                        }
                        for key, width in ipairs(widths) do
                            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                                item[key] = vm.fn.strdisplaywidth(item[key], 0, width - 1) .. '…'
                            end
                        end

                        return item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = 'CmpGhostText',
                    }
                },
                sorting = defaults.sorting,
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                view = {
                    entries = {
                        name = 'custom',
                    }
                },
            }
        end,
        main = 'Mochi.util.cmp',
    },

    -- snippets
    {
        'nvim-cmp',
        dependencies = {
            {
                'garymjr/nvim-snippets',
                opts = {
                    friendly_snippets = true,
                },
                dependencies = {
                    'rafamadriz/friendly-snippets',
                },
            }
        },
        opts = function(_, opts)
            opts.snippets = {
                expand = function(item)
                    Util.cmp.expand(item.body)
                end,
            }
            if Util.plugin.has('nvim-snippets') then
                table.insert(opts.sources, { name = 'snippets' })
            end
        end,
    },
}
