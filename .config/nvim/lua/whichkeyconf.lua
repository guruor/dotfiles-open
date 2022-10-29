local utils = require "utils"
local wk = require("which-key")

local leader = "<Space>"
local localleader = ","

local keys
local keys_visual

keys = {
    ["j"] = {":BufferPrevious<CR>", "Jump to left tab"},
    ["k"] = {":BufferNext<CR>", "Jump to right tab"},
    ["<"] = {":BufferMovePrevious<CR>", "Move tab left"},
    [">"] = {":BufferMoveNext<CR>", "Move tab right"},
    ["\\"] = {":exe 'tabn '.g:lasttab<CR>", "Last tab"},
    ["1"] = {":BufferGoto 1<CR>", "which_key_ignore"},
    ["2"] = {":BufferGoto 2<CR>", "which_key_ignore"},
    ["3"] = {":BufferGoto 3<CR>", "which_key_ignore"},
    ["4"] = {":BufferGoto 4<CR>", "which_key_ignore"},
    ["5"] = {":BufferGoto 5<CR>", "which_key_ignore"},
    ["6"] = {":BufferGoto 6<CR>", "which_key_ignore"},
    ["7"] = {":BufferGoto 7<CR>", "which_key_ignore"},
    ["8"] = {":BufferGoto 8<CR>", "which_key_ignore"},
    ["9"] = {":BufferGoto 9<CR>", "which_key_ignore"},
    ["u"] = {":update<CR>", "Save file"},
    -- Closing float windows before deleting the current buffer
    ["d"] = {":lua require'utils'.close_floating_windows();vim.api.nvim_command('bdelete')<CR>", "Delete buffer"},
    ["D"] = {":BufferCloseAllButCurrent<CR>", "Delete buffer"},
    -- Closing float windows before closing the current window
    ["q"] = {":lua require'utils'.close_floating_windows();vim.api.nvim_command('quit')<CR>", "Quit"},
    ["x"] = {":q!<CR>", "Close without saving"},
    ["Q"] = {":qa!<CR>", "Quit all"}
}


wk.register(keys, {prefix = localleader})
wk.register(keys, {prefix = localleader, mode = 'v'})

keys = {
    ["\\"] = {":TagbarToggle<CR>", "Toggle tagbar"},
    ["/"] = {":call Comment()<CR>", "Comment"},
    ["C"] = {":Code!!<CR>", "Virtual REPL"},
    ["p"] = {":Files<CR>", "Find files"},
    ["P"] = {":!opout %<CR>", "Preview files"},
    ["f"] = {":Rg<CR>", "Find text"},
    ["F"] = {':exec ":RgRaw ".input("Enter rg command (Ex: \'<search_keyword>\' <search_dir>): ", "", "shellcmd")<CR>', "Find text with raw rg command"},
    ["_"] = {"<C-W>s", "Split below"},
    ["|"] = {"<C-W>v", "Split right"},
    ["c"] = {':exec ":w! | :vs | :te compiler % ".input("Enter args: ")<CR>', "Compile"},
    ["X"] = {":split | term<CR>", "Terminal"},
    ["."] = {":tabnew $MYVIMRC<CR>", "Open Init"},
    ["R"] = {":source $MYVIMRC<CR>", "Reload Init"},
    ["U"] = {":UndotreeToggle<CR>", "Undo Tree"},
    [" "] = {":noh<CR>", "No Highlight"},
    ["L"] = {":Limelight<CR>", "Limelight activate"},
    ["o"] = {":tabnew | terminal lf<CR>", "Open file explorer"},
    ["S"] = {":%s//gc<Left><Left><Left>", "Find and replace/substitute"}
}
wk.register(keys, {prefix = leader})
wk.register(keys, {prefix = leader, mode = 'v'})

keys_visual = copy(keys)
keys_visual["S"] = {'"hy:%s/<C-r>h//gc<left><left><left>', "Find and replace/substitute visual selected"}
wk.register(keys_visual, {prefix = leader, mode = 'v'})

keys = {
    g = {
        name = 'Git',
        ["b"] = {":Git blame<CR>", "Blame"},
        ["B"] = {":.GBrowse<CR>", "Browse"},
        ["c"] = {":Git commit<CR>", "Commit"},
        ["d"] = {":Git diff<CR>", "Diff"},
        ["D"] = {":Gdiffsplit<CR>", "Diff split"},
        ["g"] = {":GGrep<CR>", "Grep"},
        ["s"] = {":Git<CR>", "Status"},
        ["l"] = {":Git log<CR>", "Log"},
        ["p"] = {":Git push<CR>", "Push"},
        ["P"] = {":Git pull<CR>", "Pull"},
        ["<"] = {":diffget //3<CR>", "Get changes from right"},
        [">"] = {":diffget //2<CR>", "Get changes from left"}
    }
}
wk.register(keys, {prefix = leader})
wk.register(keys, {prefix = leader, mode = 'v'})

keys = {
    d = {
        name = 'Debug',

        ["b"] = {"<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle Breakpoint"},
        ["B"] = {"<cmd>lua require\'dap\'.toggle_breakpoint(vim.fn.input(\'Breakpoint Condition: \'), nil, nil, true)<CR>", "Condition"},
        ["j"] = {"<cmd>lua require\'dap\'.down()<CR>", "Down in stack trace"},
        ["k"] = {"<cmd>lua require\'dap\'.up()<CR>", "Up in stack trace"},
        ["c"] = {"<cmd>lua require\'dap\'.continue()<CR>", "Continue"},
        ["n"] = {"<cmd>lua require\'dap\'.step_over()<CR>", "Step Over"},
        ["s"] = {"<cmd>lua require\'dap\'.step_into()<CR>", "Step Into"},
        ["u"] = {"<cmd>lua require\'dap\'.step_out()<CR>", "Step Out"},
        ["l"] = {"<cmd>lua require\'dap\'.toggle_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'), true)<CR>", "Log"},
        ["r"] = {"<cmd>lua require\'dap\'.repl.toggle({height=15})<CR>", "Toggle REPL"},
        ["x"] = {"<cmd>lua require\'dap\'.close()<CR>", "Stop"},
        ["t"] = {"<cmd>lua require\'dapui\'.toggle()<CR>", "DAP UI Toggle"},
        ["h"] = {"<cmd>lua require\'dap.ui.widgets\'.hover()<CR>", "Widget Hover"},
        ["S"] = {"<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>", "Widget Scopes"},
        ["dr"] = {
            ':exec ":vs | :te cargo build; rust-lldb ".input("Path to executable: ", getcwd() .. "/target/debug/", "file")." ".input("Enter args: ")<CR>',
            "rust-lldb"
        }
    }
}
wk.register(keys, {prefix = leader})
wk.register(keys, {prefix = leader, mode = 'v'})

keys = {
    l = {
        name = 'LSP',
        ["gd"] = {"<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition"},
        ["gD"] = {"<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration"},
        ["gr"] = {"<cmd>lua vim.lsp.buf.references()<CR>", "References"},
        ["gs"] = {"<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature"},
        ["gi"] = {"<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation"},
        ["gt"] = {"<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition"},
        ["gw"] = {"<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Document symbol"},
        ["gW"] = {"<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "Workspace symbol"},
        ["i"] = {"<cmd>lua vim.lsp.buf.incoming_calls()<CR>", "Incoming calls"},
        ["o"] = {"<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", "Outgoing calls"},
        ["a"] = {":lua vim.lsp.buf.code_action()<CR>", "Action"},
        ["k"] = {":lua vim.lsp.buf.hover()<CR>", "Hover"},
        ["="] = {":update | lua vim.lsp.buf.formatting()<CR>", "Format"},
        ["d"] = {":lua vim.lsp.diagnostic.set_loclist()<CR>", "Diagnostic"},
        ["D"] = {":lua vim.diagnostic.open_float(0, { scope = 'line', border = 'single' })<CR>", "Diagnostic"},
        ["dd"] = {":lua require'lsp.diagnostics'.line_diagnostics()<CR>", "Diagnostic"},
        ["n"] = {":lua vim.lsp.diagnostic.goto_next()<CR>", "Next diagnostic"},
        ["p"] = {":lua vim.lsp.diagnostic.goto_prev()<CR>", "Prev diagnostic"},
        ["q"] = {":lua require('lists').change_active('Quickfix')<CR>", "Quick fix"},
        ["r"] = {":lua require'lsp.rename'.rename()<CR>", "Rename"},
        ["R"] = {":lua require('lists').change_active('Quickfix')<CR>:lua vim.lsp.buf.references()<CR>", "References"}
    }
}
wk.register(keys, {prefix = leader})
keys_visual = copy(keys)
keys_visual["l"]["="] = {":update | lua vim.lsp.buf.range_formatting()<CR>", "Range Format"}
wk.register(keys_visual, {prefix = leader, mode = 'v'})

keys = {
    t = {
        name = 'taskrunner',
        ["r"] = {":OverseerRun<CR>", "Run a task"},
        ["t"] = {":OverseerToggle<CR>", "Toggle task list"},
        ["a"] = {":OverseerQuickAction<CR>", "Toggle quick action"},
    }
}
wk.register(keys, {prefix = leader})
wk.register(keys, {prefix = leader, mode = 'v'})

keys = {
    T = {
        name = 'Toggle',
        ["b"] = {":call ToggleBackground()<CR>", "Toggle vim background"},
        ["B"] = {":!toggle-dark-mode<CR>", "Toggle background of all apps"},
        ["n"] = {":set nonumber!<CR>", "Line numbers"},
        ["r"] = {":set norelativenumber!<CR>", "Relative line numbers"},
        ["w"] = {":set wrap!<CR>", "Word wrap"},
        ["c"] = {":ColorToggle<CR>", "Colorizer"},
        ["l"] = {":Limelight!!<CR>", "Limelight"},
        ["i"] = {":IndentLinesToggle<CR>", "Indent lines"},
        ["u"] = {":UndotreeToggle<CR>", "Undo Tree"},
        ["h"] = {":call ToggleHiddenAll()<CR>", "Hide"},
        ["z"] = {":Goyo<CR>", "Goyo"},
        ["s"] = {":set spell!<CR>", "Spell"}
    }
}
wk.register(keys, {prefix = leader})
wk.register(keys, {prefix = leader, mode = 'v'})

keys = {
    m = {
        name = 'Macro',
        ["j"] = {":!jq .<CR>", "Format selection as json"},
        ["q"] = {":%s!sqlformat --reindent --keywords upper --identifiers lower -<CR>", "Format SQL query"},
        ["n"] = {":%s/\\n/\r/g<CR>", "Replace \n with newline charFormat sqlalchemy query from logs"},
        ["{"] = {":%s/\\%V{/{{/g | %s/\\%V}/}}/g<CR>", "Replace braces with double braces for multiline formatted string"},
        ["\""] = {":%s/'/\"/g<CR>", "Replace ' with \""},
        ["'"] = {":%s/\"/'/g<CR>", "Replace \" with '"},
        ["e"] = {":!date -d @<C-R><C-W><CR>", "Epoch to System time"}
    }
}

wk.register(keys, {prefix = leader})
keys_visual = copy(keys)
keys_visual["m"]["q"] = {":'<,'>!sqlformat --reindent --keywords upper --identifiers lower -<CR>", "Format selected SQL query"}
keys_visual["m"]["\""] = {":s/'/\"/g<CR>", "Replace ' with \" for selected text"}
keys_visual["m"]["'"] = {":s/\"/'/g<CR>", "Replace \" with ' for selected text"}
wk.register(keys_visual, {prefix = leader, mode = 'v'})

keys = {
    a = {
        name = 'Authoring',
        ["c"] = {"1z=", "Correct misspelled word"},
        ["t"] = {":ThesaurusQueryReplaceCurrentWord<CR>", "Replace word under cursor with synonym"},
        ["T"] = {"y:ThesaurusQueryReplace<CR>", "Replace visual selection with synonym"}
    }
}
wk.register(keys, {prefix = leader})
wk.register(keys, {prefix = leader, mode = 'v'})

-- Adding file or buffer specific mapping with autocmds
-- Reference https://github.com/folke/which-key.nvim/issues/276#issuecomment-1117432067
local function attach_rest_nvim_keys(bufnr)
    keys = {
        r = {
            name = 'REST client',
            ["r"] = {"<Plug>RestNvim", "Run the request under the cursor"},
            ["p"] = {"<Plug>RestNvimPreview", "preview the request cURL command"},
            ["l"] = {"<Plug>RestNvimLast", "re-run the last request"},
            ["e"] = {"<Cmd>lua SelectRestNvimEnvironment()<Cr>", "Change environment"},
        }
    }
    wk.register(keys, {prefix = leader})
    wk.register(keys, {prefix = leader, mode = 'v'})
end

vim.api.nvim_create_autocmd(
    { "Filetype" },
    { pattern = { "http" }, callback = attach_rest_nvim_keys }
)

local function attach_dadbod_ui_keys(bufnr)
    keys = {
        r = {
            name = 'Dadbod DB client',
            ["t"] = {"<Cmd>DBUIToggle<Cr>", "Toggle UI"},
            ["f"] = {"<Cmd>DBUIFindBuffer<Cr>", "Find buffer"},
            ["R"] = {"<Cmd>DBUIRenameBuffer<Cr>", "Rename buffer"},
            ["q"] = {"<Cmd>DBUILastQueryInfo<Cr>", "Last query info"},
            ["r"] = {"<Plug>(DBUI_ExecuteQuery)", "Run query"},
            ["e"] = {"<Plug>(DBUI_EditBindParameters)", "Edit bind parameters"},
        }
    }
    wk.register(keys, {prefix = leader})
    wk.register(keys, {prefix = leader, mode = 'v'})
end

vim.api.nvim_create_autocmd(
    { "Filetype" },
    { pattern = { "sql" }, callback = attach_dadbod_ui_keys }
)
