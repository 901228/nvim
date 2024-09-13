local have_make = vim.fn.executable('make') == 1
local have_cmake = vim.fn.executable('cmake') == 1

return {
    -- view many things in a panel
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        version = false,
        dependencies = {
            'plenary.nvim',
            'dressing.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = have_make and 'make'
                    or 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
                enabled = have_make or have_cmake,
                config = function(plugin)
                    Util.plugin.on_loaded('telescope', function()
                        local ok, err = pcall(require('telescope').load_extension, 'fzf')
                        if not ok then
                            local lib = plugin.dir .. '/build/libfzf.' .. (Util.os.is_win and 'dll' or 'so')
                            if not vim.uv.fs_stat(lib) then
                                Util.warn('`telescope-fzf-native.nvim` not built. Rebuilding...')
                                require('lazy').build({ plugins = { plugin }, show = false }):wait(
                                    function()
                                        Util.info(
                                            'Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.'
                                        )
                                    end
                                )
                            else
                                Util.error('Failed to load `telescope-fzf-native.nvim`:\n' .. err)
                            end
                        end
                    end)
                end,
            },
        },
        keys = {
            { '<leader>ff', require('telescope.builtin').find_files, desc = 'find file' },
            { '<leader>fg', require('telescope.builtin').live_grep, desc = 'find' },
            { '<leader>fb', require('telescope.builtin').buffers, desc = 'find buffers' },
            { '<leader>fh', require('telescope.builtin').help_tags, desc = 'helps' },
            {
                '<leader>fn',
                function()
                    local tel = require('telescope')
                    tel.load_extension('notify')
                    tel.extensions.notify.notify()
                end,
                desc = 'notify history',
            },
            { '<leader>fp', require('telescope.builtin').commands, desc = 'commands' },
            { '<leader>fk', require('telescope.builtin').keymaps, desc = 'keymaps' },
            { '<leader>f', desc = '+ Telescope' },
        },
        opts = function()
            local actions = require('telescope.actions')

            local open_with_trouble = function(...) return require('trouble.sources.telescope').open(...) end

            local function find_files_no_ignore()
                local action_state = require('telescope.actions.state')
                local line = action_state.get_current_line()
                require('telescope.builtin').find_files({
                    follow = true,
                    no_ignore = true,
                    default_text = line,
                })
            end

            local function find_files_with_hidden()
                local action_state = require('telescope.actions.state')
                local line = action_state.get_current_line()
                require('telescope.builtin').find_files({
                    follow = true,
                    hidden = true,
                    default_text = line,
                })
            end

            local function find_command()
                if vim.fn.executable('rg') == 1 then
                    return { 'rg', '--files', '--color', 'never', '-g', '!.git' }
                elseif vim.fn.executable('fd') == 1 then
                    return { 'fd', '--type', 'f', '--color', 'never', '-E', '.git' }
                elseif vim.fn.executable('fdfind') == 1 then
                    return { 'fdfind', '--type', 'f', '--color', 'never', '-E', '.git' }
                elseif vim.fn.executable('find') == 1 then
                    return { 'find', '.', '-type', 'f' }
                elseif vim.fn.executable('where') == 1 then
                    return { 'where', '/r', '.', '*' }
                end
            end

            return {
                defaults = {
                    prompt_prefix = ' ',
                    selection_caret = ' ',
                    get_selection_window = function()
                        local wins = vim.api.nvim_list_wins()
                        table.insert(wins, 1, vim.api.nvim_get_current_win())
                        for _, win in ipairs(wins) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype == '' then
                                return win
                            end
                        end
                    end,
                    mappings = {
                        i = {
                            ['<C-t>'] = open_with_trouble,
                            ['<A-t>'] = open_with_trouble,
                            ['<A-i>'] = find_files_no_ignore,
                            ['<A-h>'] = find_files_with_hidden,
                            ['<C-Down>'] = actions.cycle_history_next,
                            ['<C-Up>'] = actions.cycle_history_prev,
                            ['<C-f>'] = actions.preview_scrolling_down,
                            ['<C-b>'] = actions.preview_scrolling_up,
                        },
                        n = {
                            ['q'] = actions.close,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        find_command = find_command,
                        hidden = true,
                    },
                },
            }
        end,
    },

    -- for flash
    {
        'telescope.nvim',
        opts = function(_, opts)
            if not Util.plugin.has('flash.nvim') then return end

            local function flash(prompt_bufnr)
                require('flash').jump({
                    pattern = '^',
                    label = { after = { 0, 0 } },
                    search = {
                        mode = 'search',
                        exclude = {
                            function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults' end,
                        },
                    },
                    action = function(match)
                        local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
                        picker:set_selection(match.pos[1] - 1)
                    end,
                })
            end
            opts.defaults = vim.tbl_deep_extend('force', opts.defaults or {}, {
                mappings = {
                    n = { s = flash },
                    i = { ['<C-s>'] = flash },
                },
            })
        end,
    },

    -- better telescope ui with dressing
    {
        'stevearc/dressing.nvim',
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require('lazy').load({ plugins = { 'dressing.nvim' } })
                return vim.ui.select(...)
            end

            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require('lazy').load({ plugins = { 'dressing.nvim' } })
                return vim.ui.input(...)
            end
        end,
    },
}
