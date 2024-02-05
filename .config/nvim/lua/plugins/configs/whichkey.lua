local utils = require "utils"
local wk = require("which-key")

local leader = "<Space>"
local localleader = "\\"

local keys
local keys_visual

keys = {
    name = 'Localleader mappings',
    ["P"] = { ":!opout %<CR>", "Preview files" },
    ["c"] = { ':exec ":w! | :vs | :te compiler % ".input("Enter args: ")<CR>', "Compile" },
    ["U"] = { ":UndotreeToggle<CR>", "Undo Tree" },
}

wk.register(keys, { prefix = localleader })
wk.register(keys, { prefix = localleader, mode = 'v' })

keys = {
    name = 'Leader mappings',
    ["_"] = { "<C-W>s", "Split below" },
    ["|"] = { "<C-W>v", "Split right" },
    ["o"] = { ":Lf<CR>", "Open LF file explorer" },
    ["O"] = { ":lua require('lf').start(vim.fn.getcwd())<CR>", "Open LF file explorer" },
    ["qq"] = { "<cmd>qa<cr>", "Quit all" },
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    b = {
        name = 'Buffers',
        ["b"] = { "<cmd>e #<cr>", "Switch to Other Buffer" },
        ["p"] = { ":BufferLineCyclePrev<CR>", "Jump to previous tab" },
        ["n"] = { ":BufferLineCycleNext<CR>", "Jump to next tab" },
        ["j"] = { ":BufferLineCyclePrev<CR>", "Jump to previous tab" },
        ["k"] = { ":BufferLineCycleNext<CR>", "Jump to next tab" },
        ["<lt>"] = { ":BufferLineMovePrev<CR>", "Move tab left" },
        [">"] = { ":BufferLineMoveNext<CR>", "Move tab right" },
        ["1"] = { '<cmd>lua require("bufferline").go_to(1, true)<CR>', "which_key_ignore" },
        ["2"] = { '<cmd>lua require("bufferline").go_to(2, true)<CR>', "which_key_ignore" },
        ["3"] = { '<cmd>lua require("bufferline").go_to(3, true)<CR>', "which_key_ignore" },
        ["4"] = { '<cmd>lua require("bufferline").go_to(4, true)<CR>', "which_key_ignore" },
        ["5"] = { '<cmd>lua require("bufferline").go_to(5, true)<CR>', "which_key_ignore" },
        ["6"] = { '<cmd>lua require("bufferline").go_to(6, true)<CR>', "which_key_ignore" },
        ["7"] = { '<cmd>lua require("bufferline").go_to(7, true)<CR>', "which_key_ignore" },
        ["8"] = { '<cmd>lua require("bufferline").go_to(8, true)<CR>', "which_key_ignore" },
        ["9"] = { '<cmd>lua require("bufferline").go_to(9, true)<CR>', "which_key_ignore" },
        ["u"] = { ":update<CR>", "Save file" },
        -- Closing float windows before deleting the current buffer
        ["d"] = { ":lua CloseAllFloatingWindows();vim.api.nvim_command('bdelete')<CR>", "Delete buffer" },
        ["D"] = { ":lua CloseAllFloatingWindows(); vim.api.nvim_command('bufdo bdelete');<CR>", "Delete all buffers" },
        -- Closing float windows before closing the current window
        ["q"] = { ":lua CloseAllFloatingWindows();vim.api.nvim_command('quit')<CR>", "Quit" },
        ["x"] = { ":q!<CR>", "Close without saving" },
        ["Q"] = { ":qa!<CR>", "Quit all" }
   }
}

wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    F = {
        name = 'Find stuff',
        [" "] = { ":Telescope<CR>", "Telescope" },
        ["h"] = { ":Telescope help_tags<CR>", "Help tags" },
        ["f"] = { ":lua TelescopeGrepStringWithSelection() <CR>", "Find text" },
        ["F"] = { ":lua TelescopeSearchInSpecificDirectory() <CR>", "Find in directory" },
        ["/"] = { ":lua TelescopeCurrentBufferFuzzyFindWithSelection() <CR>", "Find in buffer" },
        ["z"] = {
            ":lua require'telescope'.extensions.zoxide.list{results_title='Z Directories', prompt_title='Z Prompt'}<CR>",
            "Find z directory" },
        ["p"] = { ":Telescope fd<CR>", "Find files fd" },
        ["gf"] = { ":Telescope git_files<CR>", "Git files" },
        ["gb"] = { ":Telescope git_branches<CR>", "Git branches" },
        ["gs"] = { ":Telescope git_status<CR>", "Git status" },
        ["ld"] = { ":Telescope diagnostics<CR>", "LSP diagnostics" },
        ["lr"] = { ":Telescope lsp_references<CR>", "Find references" },
        ["lq"] = { ":Telescope quickfix<CR>", "Find quickfix" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    f = {
        name = 'Find stuff with fzf',
        [" "] = { ":FzfLua<CR>", "Fzf" },
        ["h"] = { ":FzfLua help_tags<CR>", "Help tags" },
        ["f"] = { ":FzfGrepProjectWithSelection<CR>", "Find text" },
        ["F"] = { ":FzfSearchInSpecificDirectory<CR>", "Find in directory" },
        ["/"] = { ":FzfBlinesWithSelection<CR>", "Find in buffer" },
        ["p"] = { ":FzfLua files<CR>", "Find files fd" },
        ["gf"] = { ":FzfLua git_files<CR>", "Git files" },
        ["gb"] = { ":FzfLua git_branches<CR>", "Git branches" },
        ["gs"] = { ":FzfLua git_status<CR>", "Git status" },
        ["ld"] = { ":FzfLua diagnostics_document<CR>", "LSP diagnostics" },
        ["lr"] = { ":FzfLua lsp_references<CR>", "Find references" },
        ["lq"] = { ":FzfLua quickfix<CR>", "Find quickfix" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    g = {
        name = 'Git',
        ["a"] = { ":Git commit --amend<CR>", "Ammend Commit" },
        ["b"] = { ":Git blame<CR>", "Blame" },
        ["B"] = { ":GitLink!<CR>", "Open commit in browser" },
        ["c"] = { ":Git commit<CR>", "Commit" },
        ["C"] = { ":FzfLua git_branches<CR>", "Checkout branch" },
        ["d"] = { ":DiffviewToggle<CR>", "DiffviewToggle" },
        -- ["d"] = { ":Gvdiffsplit!<CR>", "Diff vertical split" },
        ["D"] = { ":Git diff<CR>", "Diff" },
        ["m"] = { ":Git mergetool<CR>", "Git mergetool" },
        ["g"] = { ":GGrep<CR>", "Grep" },
        ["s"] = { ":Git<CR>", "Status" },
        ["l"] = { ":Git log -200 <CR>", "Last 200 commits log" },
        ["L"] = { ":tabnew | terminal lazygit<CR>", "Lazygit" },
        ["p"] = { ":Git push<CR>", "Push" },
        ["P"] = { ":Git pull<CR>", "Pull" },
        ["<lt>"] = { ":diffget //3<CR>", "Get changes from right" },
        [">"] = { ":diffget //2<CR>", "Get changes from left" },
    }
}

wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    d = {
        name = 'Debug',
        ["b"] = { ":PBToggleBreakpoint<CR>", "Toggle Breakpoint" },
        ["B"] = { ":PBClearAllBreakpoints<CR>", "Clear all breakpoints" },
        ["j"] = { "<cmd>lua require\'dap\'.down()<CR>", "Down in stack trace" },
        ["k"] = { "<cmd>lua require\'dap\'.up()<CR>", "Up in stack trace" },
        ["c"] = { "<cmd>lua require\'dap\'.continue()<CR>", "Continue" },
        ["R"] = { "<cmd> lua require('dap').run_to_cursor()<CR> ", "Run till cursor" },
        ["n"] = { "<cmd>lua require\'dap\'.step_over()<CR>", "Step Over" },
        ["s"] = { "<cmd>lua require\'dap\'.step_into()<CR>", "Step Into" },
        ["u"] = { "<cmd>lua require\'dap\'.step_out()<CR>", "Step Out" },
        ["l"] = { "<cmd>lua require\'dap\'.toggle_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'), true)<CR>",
            "Log" },
        ["r"] = { "<cmd>lua require\'dap\'.repl.toggle({height=15})<CR>", "Toggle REPL" },
        ["x"] = { "<cmd>lua require\'dap\'.close()<CR>", "Stop" },
        ["e"] = { "<cmd>lua require\'dapui\'.eval()<CR>", "DAP evaluate expression" },
        ["t"] = { "<cmd>lua require\'dapui\'.toggle()<CR>", "DAP UI Toggle" },
        ["h"] = { "<cmd>lua require\'dap.ui.widgets\'.hover()<CR>", "Widget Hover" },
        ["S"] = { "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
            "Widget Scopes" },
        ["dr"] = {
            ':exec ":vs | :te cargo build; rust-lldb ".input("Path to executable: ", getcwd() .. "/target/debug/", "file")." ".input("Enter args: ")<CR>',
            "rust-lldb"
        },
        ["N"] = { ":lua require'osv'.launch({ config_file = '~/.config/nvim/lua/initlsp.lua', port = 8086})<CR>",
            "Debug neovim lua" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    L = {
        name = 'LSP',
        ["gd"] = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
        ["gD"] = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
        ["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
        ["gs"] = { "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature" },
        ["gi"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
        ["gt"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
        ["gw"] = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Document symbol" },
        ["gW"] = { "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "Workspace symbol" },
        ["i"] = { "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", "Incoming calls" },
        ["o"] = { "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", "Outgoing calls" },
        ["a"] = { ":lua vim.lsp.buf.code_action()<CR>", "Action" },
        ["k"] = { ":lua vim.lsp.buf.hover()<CR>", "Hover" },
        ["="] = { "<cmd>update | lua require('conform').format({ async = true, lsp_fallback = true })<CR>", "Format" },
        ["dd"] = { ":lua vim.diagnostic.setloclist()<CR>", "Diagnostic" },
        ["d]"] = { ":lua vim.diagnostic.goto_next()<CR>", "Next diagnostic" },
        ["d["] = { ":lua vim.diagnostic.goto_prev()<CR>", "Prev diagnostic" },
        ["dl"] = { ":lua vim.diagnostic.open_float(0, { scope = 'line', border = 'single' })<CR>", "Line Diagnostic" },
        ["da"] = { ":lua vim.diagnostic.get()<CR>", "All diagnostic" },
        ["dq"] = { "<cmd>lua vim.diagnostic.setqflist()<CR>", "QuickFix" },
        ["r"] = { ":lua require'lsp.rename'.rename()<CR>", "Rename" },
        ["R"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    l = {
        name = 'LSP',
        ["\\"] = { ":Lspsaga outline<CR>", "Toggle outline" },
        ["gd"] = { "<Cmd>Lspsaga goto_definition()<CR>", "Definition" },
        ["gD"] = { "<Cmd>Lspsaga peek_definition()<CR>", "Peek definition" },
        ["gr"] = { "<Cmd>Lspsaga finder<CR>", "References" },
        ["gi"] = { "<Cmd>Lspsaga finder<CR>", "Implementation" },
        ["gt"] = { "<Cmd>Lspsaga peek_type_definition<CR>", "Type definition" },
        ["i"] = { "<Cmd>Lspsaga incoming_calls<CR>", "Incoming calls" },
        ["o"] = { "<Cmd>Lspsaga outgoing_calls<CR>", "Outgoing calls" },
        ["a"] = { "<Cmd>Lspsaga code_action<CR>", "Action" },
        ["k"] = { "<Cmd>Lspsaga hover_doc<CR>", "Hover" },
        ["="] = { "<cmd>update | lua require('conform').format({ async = true, lsp_fallback = true })<CR>", "Format" },
        ["dd"] = { "<Cmd>Lspsaga show_buf_diagnostics<CR>", "Diagnostic" },
        ["d]"] = { "<Cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostic" },
        ["d["] = { "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev diagnostic" },
        ["dl"] = { "<Cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostic" },
        ["da"] = { "<Cmd>Lspsaga show_buf_diagnostics<CR>", "All diagnostic" },
        ["r"] = { "<Cmd>Lspsaga rename ++project<CR>", "Rename" },
        ["R"] = { "<Cmd>Lspsaga finder<CR>", "References" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    t = {
        name = 'taskrunner',
        ["r"] = { ":OverseerRun<CR>", "Run a task" },
        ["t"] = { ":OverseerToggle<CR>", "Toggle task list" },
        ["a"] = { ":OverseerQuickAction<CR>", "Toggle quick action" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    T = {
        name = 'Toggle',
        ["b"] = { ":lua ToggleBackground()<CR>", "Toggle vim background" },
        ["B"] = { ":!toggle-dark-mode<CR>", "Toggle background of all apps" },
        ["n"] = { ":set nonumber!<CR>", "Line numbers" },
        ["ff"] = { ":FocusToggle<CR>", "Focus nvim" },
        ["r"] = { ":set norelativenumber!<CR>", "Relative line numbers" },
        ["w"] = { ":set wrap!<CR>", "Word wrap" },
        ["W"] = { ":ToggleWhitespace<CR>", "Whitespace" },
        ["c"] = { ":CccHighlighterToggle<CR>", "Color code highlight" },
        ["l"] = { ":Twilight<CR>", "Twilight" },
        ["i"] = { ":IBLToggle<CR>", "Indent lines" },
        ["u"] = { ":UndotreeToggle<CR>", "Undo Tree" },
        ["h"] = { ":lua ToggleHiddenAll()<CR>", "Hide" },
        ["z"] = { ":ZenMode<CR>", "ZenMode" },
        ["s"] = { ":lua ToggleTpipeline()<CR>", "Toggle tpipeline" },
        ["S"] = { ":set spell!<CR>", "Spell" },
        ["fc"] = { ":lua ToggleFoldcolumn()<CR>", "Toggle foldcolumn" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

keys = {
    m = {
        name = 'Macro',
        ["fj"] = { ":!jq .<CR>", "Format selection as json" },
        ["fq"] = { ":%s!sqlformat --reindent --keywords upper --identifiers lower -<CR>", "Format SQL query" },
        ["e"] = { ":!date -d @<C-R><C-W><CR>", "Epoch to System time" }
    }
}

wk.register(keys, { prefix = leader })
keys_visual = copy(keys)
keys_visual["m"]["fq"] = { ":'<,'>!sqlformat --reindent --keywords upper --identifiers lower -<CR>",
    "Format selected SQL query" }
keys_visual["m"]["j"] = { ":lua FormatQuoteAndJoin()<CR>", "Join string with comma with single quote surround" }
wk.register(keys_visual, { prefix = leader, mode = 'v' })

keys = {
    ["ms"] = {
        name = 'Substitute Macro',
        [" "] = { ":%s/<C-r><C-w>//gc<Left><Left><Left>", "Find and replace/substitute", silent = false },
        ["{"] = { ":%s/\\%V{/{{/g | %s/\\%V}/}}/g<CR>", "Replace braces with double braces for multiline formatted string" },
        ["n"] = { ":%s/\\n/\r/g<CR>", "Replace \n with newline charFormat sqlalchemy query from logs" },
    }
}

keys_visual = copy(keys)
keys_visual["ms"]["s"] = { ':s///gc<Left><Left><Left><Left>', "Find and replace/substitute inside visual selection", silent = false }
keys_visual["ms"]["v"] = { '"hy:%s/<C-r>h//gc<left><left><left>', "Find and replace/substitute visual selected", silent = false }
keys_visual["ms"][","] = { ":lua UnquoteAndSplit()<CR>", "Split lines at commas and remove quotes" }

-- Substitute commands which are common for both normal and visual mode
local commonSubstituteCommands = {
    ["\""] = { command = "/'/\"/g", description = "Replace ' with \"" },
    ["'"] = { command = "/\"/'/g", description = "Replace \" with '" },
    c = { command = "/\\(-[Hkd]\\|--data-raw\\) / \\\\\\r\\1 /g", description = "Break curl to multi-line" },
}

keys, keys_visual = AddSubstituteMappings(commonSubstituteCommands, keys, keys_visual, "ms")
wk.register(keys, { prefix = leader })
wk.register(keys_visual, { prefix = leader, mode = 'v' })

keys = {
    a = {
        name = 'Authoring',
        ["c"] = { "1z=", "Correct misspelled word" },
        ["t"] = { ":ThesaurusQueryReplaceCurrentWord<CR>", "Replace word under cursor with synonym" },
        ["T"] = { "y:ThesaurusQueryReplace <C-r>\"<CR>", "Replace visual selection with synonym", silent = false }
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

-- There are some default mappings provided by vimwiki, just extending them
keys = {
    w = {
        name = 'Vimwiki overrides',
        [" c"] = { ":CalendarH<CR>", "<Plug>CalendarH" },
        [" p"] = { ":VimwikiDiaryPrevDay<CR>", "<Plug>VimwikiDiaryPrevDay" },
        [" n"] = { ":VimwikiDiaryNextDay<CR>", "<Plug>VimwikiDiaryNextDay" },
        ["s"] = { "<Cmd>lua ChooseVimWiki()<CR>", "ChooseVimWiki (Custom VimwikiUISelect)" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })

-- Neorg mappings
keys = {
    n = {
        name = 'Neorg mappings',
        ["i"] = { "", "Insert date" },
        ["l"] = { "", "List actions" },
        ["m"] = { "", "Navigation mode" },
        ["n"] = { "", "Notes" },
        ["t"] = { "", "GTD actions" },
        ["I"] = { ":Neorg index<CR>", "Index" },
        ["j"] = { ":Neorg journal<CR>", "Journal" },
        ["e"] = { "<Cmd>exec 'Neorg export to-file /tmp/temp.md' | sleep 500m | tabe /tmp/temp.md<Cr>", "Export" },
        ["Tc"] = { ":Neorg toggle-concealer<CR>", "Toggle concealing" },
    }
}
wk.register(keys, { prefix = leader })
wk.register(keys, { prefix = leader, mode = 'v' })


-- Adding file or buffer specific mapping with autocmds
-- Reference https://github.com/folke/which-key.nvim/issues/276#issuecomment-1117432067
local function attach_rest_nvim_keys(bufnr)
    keys = {
        r = {
            name = 'REST client',
            ["r"] = { "<Plug>RestNvim", "Run the request under the cursor" },
            ["p"] = { "<Plug>RestNvimPreview", "preview the request cURL command" },
            ["l"] = { "<Plug>RestNvimLast", "re-run the last request" },
            ["e"] = { "<Cmd>lua SelectRestNvimEnvironment()<Cr>", "Change environment" },
            ["f"] = { '<Cmd>lua RestNvimRunCurrentFile()<Cr>', "Run current file" },
        }
    }
    wk.register(keys, { prefix = leader })
    wk.register(keys, { prefix = leader, mode = 'v' })
end

vim.api.nvim_create_autocmd(
    { "Filetype" },
    { pattern = { "http" }, callback = attach_rest_nvim_keys }
)

local function attach_dadbod_ui_keys(bufnr)
    keys = {
        r = {
            name = 'Dadbod DB client',
            ["t"] = { "<Cmd>DBUIToggle<Cr>", "Toggle UI" },
            ["f"] = { "<Cmd>exec 'DBUIFindBuffer' | DBUIToggle<Cr>", "Find buffer" },
            ["R"] = { "<Cmd>DBUIRenameBuffer<Cr>", "Rename buffer" },
            ["q"] = { "<Cmd>DBUILastQueryInfo<Cr>", "Last query info" },
            ["r"] = { "<Plug>(DBUI_ExecuteQuery)", "Run query" },
            ["e"] = { "<Cmd>lua ChooseDBUIConnection()<Cr>", "Change Env" },
            ["E"] = { "<Plug>(DBUI_EditBindParameters)", "Edit bind parameters" },
            ["oR"] = { "<Plug>(DBUI_ToggleResultLayout)", "Toggle result layout" },
            -- ["Rf"] = {"<Plug>(DBUI_Redraw)", "Redraw connections"}
        }
    }
    wk.register(keys, { prefix = leader })
    wk.register(keys, { prefix = leader, mode = 'v' })
end

vim.api.nvim_create_autocmd(
    { "Filetype" },
    { pattern = { "sql" }, callback = attach_dadbod_ui_keys }
)


local function attach_markdown_keys(bufnr)
    keys = {
        r = {
            name = 'Markdown',
            ["e"] = { "<Cmd>FeMaco<Cr>", "Code block edit" },
            ["r"] = { "<Cmd>MarkdownPreview<Cr>", "Markdown Preview" },
            ["t"] = { "<Cmd>MarkdownPreviewToggle<Cr>", "Markdown Preview Toggle" },
            ["x"] = { "<Cmd>MarkdownPreviewStop<Cr>", "Markdown Preview Stop" },
        }
    }
    wk.register(keys, { prefix = leader })
    wk.register(keys, { prefix = leader, mode = 'v' })
end

vim.api.nvim_create_autocmd(
    { "Filetype" },
    { pattern = { "vimwiki", "markdown" }, callback = attach_markdown_keys }
)
