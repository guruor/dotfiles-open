require("full-border"):setup()
require("session"):setup({
    sync_yanked = true,
})

th.git = th.git or {}
th.git.ignored_sign = " " -- Gitignored
th.git.untracked_sign = "?"
th.git.modified_sign = "M"
th.git.added_sign = "A"
th.git.deleted_sign = "D"
th.git.updated_sign = "U"

th.git.modified = ui.Style():fg("blue")
th.git.added = ui.Style():fg("green")
th.git.deleted = ui.Style():fg("red"):bold()
th.git.updated = ui.Style():fg("green")

require("git"):setup({ order = 0 })

require("yatline"):setup({
    --theme = my_theme,
    section_separator = { open = "", close = "" },
    part_separator = { open = "", close = "" },
    inverse_separator = { open = "", close = "" },

    style_a = {
        fg = "black",
        bg_mode = {
            normal = "white",
            select = "brightyellow",
            un_set = "brightred",
        },
    },
    style_b = { bg = "brightblack", fg = "brightwhite" },
    style_c = { bg = "black", fg = "brightwhite" },

    permissions_t_fg = "green",
    permissions_r_fg = "yellow",
    permissions_w_fg = "red",
    permissions_x_fg = "cyan",
    permissions_s_fg = "white",

    tab_width = 20,
    tab_use_inverse = false,

    selected = { icon = "󰻭", fg = "yellow" },
    copied = { icon = "", fg = "green" },
    cut = { icon = "", fg = "red" },

    total = { icon = "󰮍", fg = "yellow" },
    succ = { icon = "", fg = "green" },
    fail = { icon = "", fg = "red" },
    found = { icon = "󰮕", fg = "blue" },
    processed = { icon = "󰐍", fg = "green" },

    show_background = true,

    display_header_line = true,
    display_status_line = true,

    component_positions = { "header", "tab", "status" },

    header_line = {
        left = {
            section_a = {
                { type = "line", custom = false, name = "tabs", params = { "left" } },
            },
            section_b = {},
            section_c = {},
        },
        right = {
            section_a = {
                { type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
            },
            section_b = {
                { type = "string", custom = false, name = "date", params = { "%X" } },
            },
            section_c = {},
        },
    },

    status_line = {
        left = {
            section_a = {
                { type = "string", custom = false, name = "tab_mode" },
            },
            section_b = {
                { type = "string", custom = false, name = "hovered_size" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_path" },
                { type = "coloreds", custom = false, name = "count" },
            },
        },
        right = {
            section_a = {
                { type = "string", custom = false, name = "cursor_position" },
            },
            section_b = {
                { type = "string", custom = false, name = "cursor_percentage" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
                { type = "coloreds", custom = false, name = "permissions" },
            },
        },
    },
})
