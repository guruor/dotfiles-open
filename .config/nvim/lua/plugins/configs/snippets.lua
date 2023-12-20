local ls = require "luasnip"
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local date = function() return { os.date('%Y-%m-%d') } end

ls.config.set_config {
    history = true,
    region_check_events = "CursorMoved,CursorHold,InsertEnter",
    delete_check_events = "TextChanged",
    enable_autosnippets = true,
}

require('luasnip.loaders.from_vscode').lazy_load()
require("luasnip.loaders.from_vscode").load({
    paths = vim.fn.stdpath "config" .. "/snippets",
})

-- Check this doc for more details on custom snippet creation
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
ls.add_snippets(nil, {
    all = {
        snip({
            trig = "date",
            namr = "Date",
            dscr = "Date in the form of DD-MM-YYYY",
        }, {
            func(date, {}),
        }),
    },
    markdown = {
        snip({
            trig = "new-day",
            namr = "Notes for a fresh day",
            dscr = "Notes heading with current date"
        },
           {
               text({ "# Notes for " }), func(date, {}), text({ "",
                       "",
                   ""}),
               insert(3)
        }),
        snip({
            trig = "meta",
            namr = "Metadata",
            dscr = "Yaml metadata format for markdown"
        },
            {
                text({ "---",
                    "title: " }), insert(1, "note_title"), text({ "",
                    "author: " }), insert(2, "author"), text({ "",
                    "date: " }), func(date, {}), text({ "",
                    "categories: [" }), insert(3, ""), text({ "]",
                    "lastmod: " }), func(date, {}), text({ "",
                    "tags: [" }), insert(4), text({ "]",
                    "comments: true",
                    "---", "" }),
                insert(0)
            }),
    },
})

ls.filetype_extend('vimwiki', { 'markdown' })
