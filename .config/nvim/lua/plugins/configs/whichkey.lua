local wk = require "which-key"

local leader = "<Space>"
local localleader = "\\"

local function merge_mappings(base_mappings, override_mappings)
  local merged_mappings = vim.deepcopy(base_mappings)
  for k, v in pairs(override_mappings) do
    merged_mappings[k] = v
  end
  return merged_mappings
end

-- General mappings
local leader_mappings = {
  name = "Leader mappings",
  ["_"] = { "<C-W>s", "Split below" },
  ["|"] = { "<C-W>v", "Split right" },
  ["o"] = { ":lua require('tfm').open()<CR>", "Open TFM in current directory" },
  ["O"] = { ":lua require('tfm').open(vim.fn.getcwd())<CR>", "Open TFM in project root" },
  ["q"] = { "<cmd>close!<CR>", "Close" },
  ["Q"] = { "<cmd>qa<cr>", "Quit all" },

  b = {
    name = "Buffers",
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
    ["Q"] = { ":qa!<CR>", "Quit all" },
  },

  F = {
    name = "Find stuff",
    [" "] = { ":Telescope<CR>", "Telescope" },
    ["h"] = { ":Telescope help_tags<CR>", "Help tags" },
    ["f"] = { ":lua TelescopeGrepStringWithSelection() <CR>", "Find text" },
    ["F"] = { ":lua TelescopeSearchInSpecificDirectory() <CR>", "Find in directory" },
    ["/"] = { ":lua TelescopeCurrentBufferFuzzyFindWithSelection() <CR>", "Find in buffer" },
    ["z"] = {
      ":lua require'telescope'.extensions.zoxide.list{results_title='Z Directories', prompt_title='Z Prompt'}<CR>",
      "Find z directory",
    },
    ["p"] = { ":Telescope fd<CR>", "Find files fd" },
    ["gf"] = { ":Telescope git_files<CR>", "Git files" },
    ["gb"] = { ":Telescope git_branches<CR>", "Git branches" },
    ["gs"] = { ":Telescope git_status<CR>", "Git status" },
    ["ld"] = { ":Telescope diagnostics<CR>", "LSP diagnostics" },
    ["lr"] = { ":Telescope lsp_references<CR>", "Find references" },
    ["lq"] = { ":Telescope quickfix<CR>", "Find quickfix" },
  },

  f = {
    name = "Find stuff with fzf",
    [" "] = { ":FzfLua<CR>", "Fzf" },
    ["r"] = { ":GrugFar<CR>", "Find and Replace" },
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
  },

  g = {
    name = "Git",
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
  },

  d = {
    name = "Debug",
    ["b"] = { ":PBToggleBreakpoint<CR>", "Toggle Breakpoint" },
    ["B"] = { ":PBClearAllBreakpoints<CR>", "Clear all breakpoints" },
    ["j"] = { "<cmd>lua require'dap'.down()<CR>", "Down in stack trace" },
    ["k"] = { "<cmd>lua require'dap'.up()<CR>", "Up in stack trace" },
    ["c"] = { "<cmd>lua require'dap'.continue()<CR>", "Continue" },
    ["R"] = { "<cmd> lua require('dap').run_to_cursor()<CR> ", "Run till cursor" },
    ["n"] = { "<cmd>lua require'dap'.step_over()<CR>", "Step Over" },
    ["s"] = { "<cmd>lua require'dap'.step_into()<CR>", "Step Into" },
    ["u"] = { "<cmd>lua require'dap'.step_out()<CR>", "Step Out" },
    ["l"] = {
      "<cmd>lua require'dap'.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '), true)<CR>",
      "Log",
    },
    ["r"] = { "<cmd>lua require'dap'.repl.toggle({height=15})<CR>", "Toggle REPL" },
    ["x"] = { "<cmd>lua require'dap'.close()<CR>", "Stop" },
    ["e"] = { "<cmd>lua require'dapui'.eval()<CR>", "DAP evaluate expression" },
    ["t"] = { "<cmd>lua require'dapui'.toggle()<CR>", "DAP UI Toggle" },
    ["h"] = { "<cmd>lua require'dap.ui.widgets'.hover()<CR>", "Widget Hover" },
    ["S"] = {
      "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
      "Widget Scopes",
    },
    ["dr"] = {
      ':exec ":vs | :te cargo build; rust-lldb ".input("Path to executable: ", getcwd() .. "/target/debug/", "file")." ".input("Enter args: ")<CR>',
      "rust-lldb",
    },
    ["N"] = {
      ":lua require'osv'.launch({ config_file = '~/.config/nvim/lua/initlsp.lua', port = 8086})<CR>",
      "Debug neovim lua",
    },
  },

  l = {
    name = "LSP",
    ["="] = { "<cmd>update | lua require('conform').format({ async = true, lsp_fallback = true })<CR>", "Format" },
    ["\\"] = { "<Cmd>AerialToggle<CR>", "Toggle outline" },
    ["da"] = { "<Cmd>FzfLua lsp_document_diagnostics<CR>", "All diagnostic" },
    ["dl"] = { "<Cmd>lua vim.diagnostic.open_float(0, { scope = 'line', border = 'single' })<CR>", "Line Diagnostic" },
    ["i"] = { "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", "Incoming calls" },
    ["l"] = { "<Cmd>lua require('lint').try_lint()<CR>", "Trigger linter" },
    ["o"] = { "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", "Outgoing calls" },
    ["sd"] = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Symbols Document" },
    ["sw"] = { "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "Symbols Workspace" },
  },

  L = { "<cmd>Lazy<CR>", "Lazy plugin manager" },

  t = {
    name = "taskrunner",
    ["r"] = { ":OverseerRun<CR>", "Run a task" },
    ["t"] = { ":OverseerToggle<CR>", "Toggle task list" },
    ["a"] = { ":OverseerQuickAction<CR>", "Toggle quick action" },
  },

  T = {
    name = "Toggle",
    ["b"] = { ":lua ToggleBackground()<CR>", "Toggle vim background" },
    ["B"] = { ":!toggle-dark-mode<CR>", "Toggle background of all apps" },
    ["n"] = { ":set nonumber!<CR>", "Line numbers" },
    ["ff"] = { ":FocusToggle<CR>", "Focus nvim" },
    ["r"] = { ":set norelativenumber!<CR>", "Relative line numbers" },
    ["w"] = { ":set wrap!<CR>", "Word wrap" },
    ["c"] = { ":CccHighlighterToggle<CR>", "Color code highlight" },
    ["l"] = { ":Twilight<CR>", "Twilight" },
    ["i"] = { ":IBLToggle<CR>", "Indent lines" },
    ["u"] = { ":UndotreeToggle<CR>", "Undo Tree" },
    ["h"] = { ":lua ToggleHiddenAll()<CR>", "Hide" },
    ["z"] = { ":ZenMode<CR>", "ZenMode" },
    ["s"] = { ":lua ToggleTpipeline()<CR>", "Toggle tpipeline" },
    ["S"] = { ":set spell!<CR>", "Spell" },
    ["fc"] = { ":lua ToggleFoldcolumn()<CR>", "Toggle foldcolumn" },
  },

  a = {
    name = "Authoring",
    ["c"] = { "1z=", "Correct misspelled word" },
    ["t"] = { ":ThesaurusQueryReplaceCurrentWord<CR>", "Replace word under cursor with synonym" },
    ["T"] = { 'y:ThesaurusQueryReplace <C-r>"<CR>', "Replace visual selection with synonym", silent = false },
  },

  -- There are some default mappings provided by vimwiki, just extending them
  w = {
    name = "Vimwiki overrides",
    [" c"] = { ":CalendarH<CR>", "<Plug>CalendarH" },
    [" p"] = { ":VimwikiDiaryPrevDay<CR>", "<Plug>VimwikiDiaryPrevDay" },
    [" n"] = { ":VimwikiDiaryNextDay<CR>", "<Plug>VimwikiDiaryNextDay" },
    ["s"] = { "<Cmd>lua ChooseVimWiki()<CR>", "ChooseVimWiki (Custom VimwikiUISelect)" },
  },

  n = {
    name = "Neorg mappings",
    ["i"] = { "", "Insert date" },
    ["l"] = { "", "List actions" },
    ["m"] = { "", "Navigation mode" },
    ["n"] = { "", "Notes" },
    ["t"] = { "", "GTD actions" },
    ["I"] = { ":Neorg index<CR>", "Index" },
    ["j"] = { ":Neorg journal<CR>", "Journal" },
    ["e"] = { "<Cmd>exec 'Neorg export to-file /tmp/temp.md' | sleep 500m | tabe /tmp/temp.md<Cr>", "Export" },
    -- Requires clipboard https://github.com/Slackadays/Clipboard
    ["y"] = {
      "<Cmd>exec 'Neorg export to-file /tmp/temp.md' | sleep 500m | !cat /tmp/temp.md | cb copy<Cr>",
      "Copy as markdown",
    },
    ["Tc"] = { ":Neorg toggle-concealer<CR>", "Toggle concealing" },
  },

  m = {
    name = "Macro",
    ["fj"] = { ":!jq .<CR>", "Format selection as json" },
    ["fq"] = { ":%s!sqlformat --reindent --keywords upper --identifiers lower -<CR>", "Format SQL query" },
    ["re"] = { ":!date -d @<C-R><C-W><CR>", "Epoch to System time" },
  },

  ["ms"] = {
    name = "Substitute Macro",
    [" "] = { ":%s/<C-r><C-w>//gc<Left><Left><Left>", "Find and replace/substitute", silent = false },
    ["{"] = { ":%s/\\%V{/{{/g | %s/\\%V}/}}/g<CR>", "Replace braces with double braces for multiline formatted string" },
    ["n"] = { ":%s/\\n/\r/g<CR>", "Replace \n with newline charFormat sqlalchemy query from logs" },
  },
}

local visual_leader_mappings = {
  ["mfq"] = { ":'<,'>!sqlformat --reindent --keywords upper --identifiers lower -<CR>", "Format selected SQL query" },
  ["mj"] = { ":lua FormatQuoteAndJoin()<CR>", "Join string with comma with single quote surround" },
  ["mss"] = { ":s///gc<Left><Left><Left><Left>", "Find and replace/substitute inside visual selection", silent = false },
  ["msv"] = { '"hy:%s/<C-r>h//gc<left><left><left>', "Find and replace/substitute visual selected", silent = false },
  ["ms,"] = { ":lua UnquoteAndSplit()<CR>", "Split lines at commas and remove quotes" },
}

-- Generating substitute commands mapping which are common for both normal and visual mode
local commonSubstituteCommands = {
  ['"'] = { command = [[/'/"/g]], description = "Replace ' with \"" },
  ["'"] = { command = [[/"/'/g]], description = "Replace \" with '" },
  c = { command = [[/\(-[Hkd]\|--data-raw\) / \r\1 /g]], description = "Break curl to multi-line" },
  l = { command = [[/\( AND\| OR\)/ \r\1/g]], description = "Break lucene query" },
  q = { command = [[/\([^, ]\+\)/'\1'/g]], description = "Quote surround strings" },
}

leader_mappings, visual_leader_mappings =
  AddSubstituteMappings(commonSubstituteCommands, leader_mappings, visual_leader_mappings, "ms")
visual_leader_mappings = merge_mappings(leader_mappings, visual_leader_mappings)

-- Filetype specific mappings should go with localleader
local filetype_mappings = {
  http = {
    r = {
      name = "REST client",
      ["r"] = { "<Plug>RestNvim", "Run the request under the cursor" },
      ["p"] = { "<Plug>RestNvimPreview", "preview the request cURL command" },
      ["l"] = { "<Plug>RestNvimLast", "re-run the last request" },
      ["e"] = { "<Cmd>lua SelectRestNvimEnvironment()<Cr>", "Change environment" },
      ["f"] = { "<Cmd>lua RestNvimRunCurrentFile()<Cr>", "Run current file" },
    },
  },
  sql = {
    r = {
      name = "Dadbod DB client",
      ["t"] = { "<Cmd>DBUIToggle<Cr>", "Toggle UI" },
      ["f"] = { "<Cmd>exec 'DBUIFindBuffer' | DBUIToggle<Cr>", "Find buffer" },
      ["R"] = { "<Cmd>DBUIRenameBuffer<Cr>", "Rename buffer" },
      ["q"] = { "<Cmd>DBUILastQueryInfo<Cr>", "Last query info" },
      ["r"] = { "<Plug>(DBUI_ExecuteQuery)", "Run query" },
      ["e"] = { "<Cmd>lua ChooseDBUIConnection()<Cr>", "Change Env" },
      ["E"] = { "<Plug>(DBUI_EditBindParameters)", "Edit bind parameters" },
      ["oR"] = { "<Plug>(DBUI_ToggleResultLayout)", "Toggle result layout" },
      -- ["Rf"] = {"<Plug>(DBUI_Redraw)", "Redraw connections"}
    },
  },
  markdown = {
    r = {
      name = "Markdown",
      ["e"] = { "<Cmd>FeMaco<Cr>", "Code block edit" },
      ["r"] = { "<Cmd>MarkdownPreview<Cr>", "Markdown Preview" },
      ["t"] = { "<Cmd>MarkdownPreviewToggle<Cr>", "Markdown Preview Toggle" },
      ["x"] = { "<Cmd>MarkdownPreviewStop<Cr>", "Markdown Preview Stop" },
    },
  },
  ["*"] = {
    name = "Localleader mappings",
    ["P"] = { ":!opout %<CR>", "Preview files" },
    ["c"] = { ':exec ":w! | :vs | :te compiler % ".input("Enter args: ")<CR>', "Compile" },
  },
}

-- Common mappings for multiple filetypes
local common_mappings = {
  markdown = { "markdown", "vimwiki" },
}

-- Adding file or buffer specific mapping with autocmds
-- Reference https://github.com/folke/which-key.nvim/issues/276#issuecomment-1117432067
local function register_mappings_for_filetypes(ft_list, mappings)
  for _, ft in ipairs(ft_list) do
    vim.api.nvim_create_augroup("which_key_" .. ft, { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = ft,
      callback = function()
        wk.register(mappings, { prefix = localleader })
        wk.register(mappings, { mode = "v", prefix = localleader })
      end,
      group = "which_key_" .. ft,
    })
  end
end

local function register_filetype_mappings()
  for ft, mappings in pairs(filetype_mappings) do
    register_mappings_for_filetypes({ ft }, mappings)
  end

  for base_ft, ft_list in pairs(common_mappings) do
    local mappings = filetype_mappings[base_ft]
    if mappings then
      register_mappings_for_filetypes(ft_list, mappings)
    end
  end
end

local function register_leader_mappings()
  wk.register(leader_mappings, { prefix = leader })
  wk.register(visual_leader_mappings, { prefix = leader, mode = "v" })
end

local M = {
  load = function()
    register_leader_mappings()
    register_filetype_mappings()
    -- Manually trigger the FileType event to apply mappings for already opened buffers
    vim.cmd "doautocmd FileType"
  end,
}

return M
