require('neo-tree').setup({
    sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
    },
    auto_clean_after_session_restore = false, -- Automatically clean up broken neo-tree buffers saved in sessions
    close_if_last_window = true,
    open_files_in_last_window = false, -- false = open files in top left window
    source_selector = {
        winbar = true,
        statusline = false,
        sources = {
            { source = "filesystem" },
            { source = "document_symbols" },
            { source = "git_status" },
        },
        content_layout = "start",
        tabs_layout = "focus",
    },
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
        git_status = {
            symbols = {
                -- Change type
                added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                deleted   = "✖",-- this can only be used in the git_status source
                renamed   = "󰁕",-- this can only be used in the git_status source
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "󰄱",
                staged    = "",
                conflict  = "",
            }
        },
    },
    renderers = {
        directory = {
            {
                "indent",
                with_markers = false,
                with_expanders = true,
            },
            { "icon" },
            { "current_filter" },
            {
                "container",
                content = {
                    { "name", zindex = 10 },
                    {
                        "symlink_target",
                        zindex = 10,
                        highlight = "NeoTreeSymbolicLinkTarget",
                    },
                    { "clipboard", zindex = 10 },
                    { "diagnostics", errors_only = true, zindex = 20, align = "right", hide_when_expanded = true },
                    { "git_status", zindex = 10, align = "right", hide_when_expanded = true },
                    { "file_size", zindex = 10, align = "right" },
                    { "type", zindex = 10, align = "right" },
                    { "last_modified", zindex = 10, align = "right" },
                    { "created", zindex = 10, align = "right" },
                },
            },
        },
    },
    window = {
        position = 'left',
        width = '25%',
        mappings = {
            ["<C-h>"] = "prev_source",
            ["<C-l>"] = "next_source",
        },
    },
    filesystem = {
        hijack_netrw_behavior = 'disabled',
    },
})
