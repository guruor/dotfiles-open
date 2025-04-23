local wk = require "which-key"

local leader = "<Space>"
local localleader = "\\"

local function merge_mappings(base_mappings, override_mappings)
  local merged_mappings = vim.deepcopy(base_mappings)
  table.insert(merged_mappings, override_mappings)
  return merged_mappings
end

-- General mappings
local leader_mappings = {
  mode = { "n", "v" },
  { leader, group = "Leader mappings" },
  { leader .. "_", "<C-W>s", desc = "Split below" },
  { leader .. "|", "<C-W>v", desc = "Split right" },
  { leader .. "o", ":lua require('tfm').open()<CR>", desc = "Open TFM in current directory" },
  { leader .. "O", ":lua require('tfm').open(vim.fn.getcwd())<CR>", desc = "Open TFM in project root" },
  { leader .. "q", "<cmd>close!<CR>", desc = "Close" },
  { leader .. "Q", "<cmd>qa<cr>", desc = "Quit all" },

  { leader .. "b", group = "Buffers" },
  { leader .. "bb", "<cmd>e #<cr>", desc = "Switch to Other Buffer" },
  { leader .. "bp", ":BufferLineCyclePrev<CR>", desc = "Jump to previous tab" },
  { leader .. "bn", ":BufferLineCycleNext<CR>", desc = "Jump to next tab" },
  { leader .. "bj", ":BufferLineCyclePrev<CR>", desc = "Jump to previous tab" },
  { leader .. "bk", ":BufferLineCycleNext<CR>", desc = "Jump to next tab" },
  { leader .. "b<lt>", ":BufferLineMovePrev<CR>", desc = "Move tab left" },
  { leader .. "b>", ":BufferLineMoveNext<CR>", desc = "Move tab right" },
  { leader .. "b1", '<cmd>lua require("bufferline").go_to(1, true)<CR>', hidden = true },
  { leader .. "b2", '<cmd>lua require("bufferline").go_to(2, true)<CR>', hidden = true },
  { leader .. "b3", '<cmd>lua require("bufferline").go_to(3, true)<CR>', hidden = true },
  { leader .. "b4", '<cmd>lua require("bufferline").go_to(4, true)<CR>', hidden = true },
  { leader .. "b5", '<cmd>lua require("bufferline").go_to(5, true)<CR>', hidden = true },
  { leader .. "b6", '<cmd>lua require("bufferline").go_to(6, true)<CR>', hidden = true },
  { leader .. "b7", '<cmd>lua require("bufferline").go_to(7, true)<CR>', hidden = true },
  { leader .. "b8", '<cmd>lua require("bufferline").go_to(8, true)<CR>', hidden = true },
  { leader .. "b9", '<cmd>lua require("bufferline").go_to(9, true)<CR>', hidden = true },
  { leader .. "bu", ":update<CR>", desc = "Save file" },
  -- Closing float windows before deleting the current buffer
  { leader .. "bd", ":lua CloseAllFloatingWindows();vim.api.nvim_command('bdelete')<CR>", desc = "Delete buffer" },
  {
    leader .. "bD",
    ":lua CloseAllFloatingWindows(); vim.api.nvim_command('bufdo bdelete');<CR>",
    desc = "Delete all buffers",
  },
  -- Closing float windows before closing the current window
  { leader .. "bq", ":lua CloseAllFloatingWindows();vim.api.nvim_command('quit')<CR>", desc = "Quit" },
  { leader .. "bx", ":q!<CR>", desc = "Close without saving" },
  { leader .. "bQ", ":qa!<CR>", desc = "Quit all" },

  { leader .. "F", group = "Find stuff" },
  { leader .. "F ", ":Telescope<CR>", desc = "Telescope" },
  { leader .. "Fh", ":Telescope help_tags<CR>", desc = "Help tags" },
  { leader .. "Ff", ":lua TelescopeGrepStringWithSelection() <CR>", desc = "Find text" },
  { leader .. "FF", ":lua TelescopeSearchInSpecificDirectory() <CR>", desc = "Find in directory" },
  { leader .. "F/", ":lua TelescopeCurrentBufferFuzzyFindWithSelection() <CR>", desc = "Find in buffer" },
  {
    leader .. "Fz",
    ":lua require'telescope'.extensions.zoxide.list{results_title='Z Directories', prompt_title='Z Prompt'}<CR>",
    desc = "Find z directory",
  },
  { leader .. "Fp", ":Telescope fd<CR>", desc = "Find files fd" },
  { leader .. "Fgf", ":Telescope git_files<CR>", desc = "Git files" },
  { leader .. "Fgb", ":Telescope git_branches<CR>", desc = "Git branches" },
  { leader .. "Fgs", ":Telescope git_status<CR>", desc = "Git status" },
  { leader .. "Fld", ":Telescope diagnostics<CR>", desc = "LSP diagnostics" },
  { leader .. "Flr", ":Telescope lsp_references<CR>", desc = "Find references" },
  { leader .. "Flq", ":Telescope quickfix<CR>", desc = "Find quickfix" },

  { leader .. "f", group = "Find stuff with fzf" },
  { leader .. "f ", ":FzfLua<CR>", desc = "Fzf" },
  { leader .. "fr", ":GrugFar<CR>", desc = "Find and Replace" },
  { leader .. "fh", ":FzfLua help_tags<CR>", desc = "Help tags" },
  { leader .. "ff", ":FzfGrepProjectWithSelection<CR>", desc = "Find text" },
  { leader .. "fF", ":FzfSearchInSpecificDirectory<CR>", desc = "Find in directory" },
  { leader .. "f/", ":FzfBlinesWithSelection<CR>", desc = "Find in buffer" },
  { leader .. "fp", ":FzfLua files<CR>", desc = "Find files fd" },
  { leader .. "fgf", ":FzfLua git_files<CR>", desc = "Git files" },
  { leader .. "fgb", ":FzfLua git_branches<CR>", desc = "Git branches" },
  { leader .. "fgs", ":FzfLua git_status<CR>", desc = "Git status" },
  { leader .. "fld", ":FzfLua diagnostics_document<CR>", desc = "LSP diagnostics" },
  { leader .. "flr", ":FzfLua lsp_references<CR>", desc = "Find references" },
  { leader .. "flq", ":FzfLua quickfix<CR>", desc = "Find quickfix" },

  { leader .. "g", group = "Git" },
  { leader .. "ga", ":Git commit --amend<CR>", desc = "Ammend Commit" },
  { leader .. "gb", ":Git blame<CR>", desc = "Blame" },
  { leader .. "gB", ":GitLink!<CR>", desc = "Open commit in browser" },
  { leader .. "gc", ":Git commit<CR>", desc = "Commit" },
  { leader .. "gC", ":FzfLua git_branches<CR>", desc = "Checkout branch" },
  { leader .. "gd", ":DiffviewToggle<CR>", desc = "DiffviewToggle" },
  -- { leader .. "gd", ":Gvdiffsplit!<CR>", desc = "Diff vertical split" },
  { leader .. "gD", ":Git diff<CR>", desc = "Diff" },
  { leader .. "gm", ":Git mergetool<CR>", desc = "Git mergetool" },
  { leader .. "gg", ":GGrep<CR>", desc = "Grep" },
  { leader .. "gs", ":Git<CR>", desc = "Status" },
  { leader .. "gl", ":Git log -200 <CR>", desc = "Last 200 commits log" },
  { leader .. "gL", ":tabnew | terminal lazygit<CR>", desc = "Lazygit" },
  { leader .. "gp", ":Git push<CR>", desc = "Push" },
  { leader .. "gP", ":Git pull<CR>", desc = "Pull" },
  { leader .. "g<lt>", ":diffget //3<CR>", desc = "Get changes from right" },
  { leader .. "g>", ":diffget //2<CR>", desc = "Get changes from left" },

  { leader .. "d", group = "Debug" },
  { leader .. "db", ":PBToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
  { leader .. "dB", ":PBClearAllBreakpoints<CR>", desc = "Clear all breakpoints" },
  { leader .. "dj", "<cmd>lua require'dap'.down()<CR>", desc = "Down in stack trace" },
  { leader .. "dk", "<cmd>lua require'dap'.up()<CR>", desc = "Up in stack trace" },
  { leader .. "dc", "<cmd>lua require'dap'.continue()<CR>", desc = "Continue" },
  { leader .. "dR", "<cmd> lua require('dap').run_to_cursor()<CR> ", desc = "Run till cursor" },
  { leader .. "dn", "<cmd>lua require'dap'.step_over()<CR>", desc = "Step Over" },
  { leader .. "ds", "<cmd>lua require'dap'.step_into()<CR>", desc = "Step Into" },
  { leader .. "du", "<cmd>lua require'dap'.step_out()<CR>", desc = "Step Out" },
  {
    leader .. "dl",
    "<cmd>lua require'dap'.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '), true)<CR>",
    desc = "Log",
  },
  { leader .. "dr", "<cmd>lua require'dap'.repl.toggle({height=15})<CR>", desc = "Toggle REPL" },
  { leader .. "dx", "<cmd>lua require'dap'.close()<CR>", desc = "Stop" },
  { leader .. "de", "<cmd>lua require'dapui'.eval()<CR>", desc = "DAP evaluate expression" },
  { leader .. "dt", "<cmd>lua require'dapui'.toggle()<CR>", desc = "DAP UI Toggle" },
  { leader .. "dh", "<cmd>lua require'dap.ui.widgets'.hover()<CR>", desc = "Widget Hover" },
  {
    leader .. "dS",
    "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
    desc = "Widget Scopes",
  },
  {
    leader .. "ddr",
    ':exec ":vs | :te cargo build; rust-lldb ".input("Path to executable: ", getcwd() .. "/target/debug/", "file")." ".input("Enter args: ")<CR>',
    desc = "rust-lldb",
  },
  {
    leader .. "dN",
    ":lua require'osv'.launch({ config_file = '~/.config/nvim/lua/initlsp.lua', port = 8086})<CR>",
    desc = "Debug neovim lua",
  },

  { leader .. "l", group = "LSP" },
  {
    leader .. "l=",
    "<cmd>update | lua require('conform').format({ async = true, lsp_fallback = true })<CR>",
    desc = "Format",
  },
  { leader .. "l\\", "<Cmd>AerialToggle<CR>", desc = "Toggle outline" },
  { leader .. "lda", "<Cmd>FzfLua lsp_document_diagnostics<CR>", desc = "All diagnostic" },
  {
    leader .. "ldl",
    "<Cmd>lua vim.diagnostic.open_float(0, { scope = 'line', border = 'single' })<CR>",
    desc = "Line Diagnostic",
  },
  {
    leader .. "ldy",
    "<Cmd>lua CopyDiagnostics()<CR>",
    desc = "Yank Line Diagnostic",
  },
  { leader .. "li", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", desc = "Incoming calls" },
  { leader .. "ll", "<Cmd>lua require('lint').try_lint()<CR>", desc = "Trigger linter" },
  { leader .. "lo", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", desc = "Outgoing calls" },
  { leader .. "lsd", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", desc = "Symbols Document" },
  { leader .. "lsw", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", desc = "Symbols Workspace" },

  { leader .. "L", "<cmd>Lazy<CR>", desc = "Lazy plugin manager" },

  { leader .. "t", group = "taskrunner" },
  { leader .. "tr", ":OverseerRun<CR>", desc = "Run a task" },
  { leader .. "tt", ":OverseerToggle<CR>", desc = "Toggle task list" },
  { leader .. "ta", ":OverseerQuickAction<CR>", desc = "Toggle quick action" },

  { leader .. "T", group = "Toggle" },
  { leader .. "Tb", ":lua ToggleBackground()<CR>", desc = "Toggle vim background" },
  { leader .. "TB", ":!toggle-dark-mode<CR>", desc = "Toggle background of all apps" },
  { leader .. "Tn", ":set nonumber!<CR>", desc = "Line numbers" },
  { leader .. "Tff", ":FocusToggle<CR>", desc = "Focus nvim" },
  { leader .. "Tr", ":set norelativenumber!<CR>", desc = "Relative line numbers" },
  { leader .. "Tw", ":set wrap!<CR>", desc = "Word wrap" },
  { leader .. "Tc", ":CccHighlighterToggle<CR>", desc = "Color code highlight" },
  { leader .. "Tl", ":Twilight<CR>", desc = "Twilight" },
  { leader .. "Ti", ":IBLToggle<CR>", desc = "Indent lines" },
  { leader .. "Tu", ":UndotreeToggle<CR>", desc = "Undo Tree" },
  { leader .. "Th", ":lua ToggleHiddenAll()<CR>", desc = "Hide" },
  { leader .. "Tz", ":ZenMode<CR>", desc = "ZenMode" },
  { leader .. "Ts", ":lua ToggleTpipeline()<CR>", desc = "Toggle tpipeline" },
  { leader .. "TS", ":set spell!<CR>", desc = "Spell" },
  { leader .. "Tfc", ":lua ToggleFoldcolumn()<CR>", desc = "Toggle foldcolumn" },

  { leader .. "a", group = "AI" },
  -- AI bindings are defined in copilot.lua
  { leader .. "A", group = "Authoring" },
  { leader .. "Ac", "1z=", desc = "Correct misspelled word" },
  { leader .. "At", ":ThesaurusQueryReplaceCurrentWord<CR>", desc = "Replace word under cursor with synonym" },
  {
    leader .. "AI",
    'y:ThesaurusQueryReplace <C-r>"<CR>',
    desc = "Replace visual selection with synonym",
    silent = false,
  },

  -- There are some default mappings provided by vimwiki, just extending them
  { leader .. "w", group = "Vimwiki overrides" },
  { leader .. "w c", ":CalendarH<CR>", desc = "<Plug>CalendarH" },
  { leader .. "w p", ":VimwikiDiaryPrevDay<CR>", desc = "<Plug>VimwikiDiaryPrevDay" },
  { leader .. "w n", ":VimwikiDiaryNextDay<CR>", desc = "<Plug>VimwikiDiaryNextDay" },
  { leader .. "ws", "<Cmd>lua ChooseVimWiki()<CR>", desc = "ChooseVimWiki (Custom VimwikiUISelect)" },

  { leader .. "n", group = "Neorg mappings" },
  { leader .. "nI", ":Neorg index<CR>", desc = "Index" },
  { leader .. "nj", ":Neorg journal<CR>", desc = "Journal" },

  { leader .. "m", group = "Macro" },
  { leader .. "mfj", ":!jq .<CR>", desc = "Format selection as json" },
  { leader .. "mfq", ":%s!sqlformat --reindent --keywords upper --identifiers lower -<CR>", desc = "Format SQL query" },
  { leader .. "mre", ":!date -d @<C-R><C-W><CR>", desc = "Epoch to System time" },

  { leader .. "ms", group = "Substitute Macro" },
  { leader .. "ms ", ":%s/<C-r><C-w>//gc<Left><Left><Left>", desc = "Find and replace/substitute", silent = false },
  {
    leader .. "ms{",
    ":%s/\\%V{/{{/g | %s/\\%V}/}}/g<CR>",
    desc = "Replace braces with double braces for multiline formatted string",
  },
  { leader .. "msn", ":%s/\\n/\r/g<CR>", desc = "Replace \n with newline charFormat sqlalchemy query from logs" },
  { leader .. "ms^", ":%s/\\r$//g<CR>", desc = "Replace \n with newline charFormat sqlalchemy query from logs" },
}

local visual_leader_mappings = {
  mode = { "v" },
  {
    leader .. "mfq",
    ":'<,'>!sqlformat --reindent --keywords upper --identifiers lower -<CR>",
    desc = "Format selected SQL query",
  },
  { leader .. "mj", ":lua FormatQuoteAndJoin()<CR>", desc = "Join string with comma with single quote surround" },
  {
    leader .. "mss",
    ":s///gc<Left><Left><Left><Left>",
    desc = "Find and replace/substitute inside visual selection",
    silent = false,
  },
  {
    leader .. "msv",
    '"hy:%s/<C-r>h//gc<left><left><left>',
    desc = "Find and replace/substitute visual selected",
    silent = false,
  },
  { leader .. "ms,", ":lua UnquoteAndSplit()<CR>", desc = "Split lines at commas and remove quotes" },
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
  AddSubstituteMappings(commonSubstituteCommands, leader_mappings, visual_leader_mappings, leader .. "ms")
visual_leader_mappings = merge_mappings(leader_mappings, visual_leader_mappings)

-- Filetype specific mappings should go with localleader
local filetype_mappings = {
  http = {
    mode = { "n", "v" },
    { localleader .. "r", group = "REST client" },
    { localleader .. "rr", "<Plug>RestNvim", desc = "Run the request under the cursor" },
    { localleader .. "rp", "<Plug>RestNvimPreview", desc = "preview the request cURL command" },
    { localleader .. "rl", "<Plug>RestNvimLast", desc = "re-run the last request" },
    { localleader .. "re", "<Cmd>lua SelectRestNvimEnvironment()<Cr>", desc = "Change environment" },
    { localleader .. "rf", "<Cmd>lua RestNvimRunCurrentFile()<Cr>", desc = "Run current file" },
  },
  sql = {
    mode = { "n", "v" },
    { localleader .. "r", group = "Dadbod DB client" },
    { localleader .. "rt", "<Cmd>DBUIToggle<Cr>", desc = "Toggle UI" },
    { localleader .. "rf", "<Cmd>exec 'DBUIFindBuffer' | DBUIToggle<Cr>", desc = "Find buffer" },
    { localleader .. "rR", "<Cmd>DBUIRenameBuffer<Cr>", desc = "Rename buffer" },
    { localleader .. "rq", "<Cmd>DBUILastQueryInfo<Cr>", desc = "Last query info" },
    { localleader .. "rr", "<Plug>(DBUI_ExecuteQuery)", desc = "Run query" },
    { localleader .. "re", "<Cmd>lua ChooseDBUIConnection()<Cr>", desc = "Change Env" },
    { localleader .. "rE", "<Plug>(DBUI_EditBindParameters)", desc = "Edit bind parameters" },
    { localleader .. "roR", "<Plug>(DBUI_ToggleResultLayout)", desc = "Toggle result layout" },
    { localleader .. "rc", group = "Database config" },
    -- { localleader .. "rcd", "<Cmd>cd $DB_CONNECTIONS_FILEPATH; sops --decrypt --in-place connections.yaml<Cr>", desc = "Decrypt DB config" },
    {
      localleader .. "rcd",
      "<Cmd>lua vim.fn.system('cd ' .. vim.fn.getenv('DB_CONNECTIONS_FILEPATH') .. ' && sops --decrypt --in-place connections.yaml')<Cr>",
      desc = "Decrypt DB config"
    },
    {
      localleader .. "rce",
      "<Cmd>lua vim.fn.system('cd ' .. vim.fn.getenv('DB_CONNECTIONS_FILEPATH') .. ' && sops --encrypt --in-place connections.yaml')<Cr>",
      desc = "Encrypt DB config"
    },
    {
      localleader .. "rca",
      "<Cmd>edit " .. vim.fn.getenv('DB_CONNECTIONS_FILEPATH') .. "/connections.yaml<Cr>",
      desc = "Edit DB config"
    },
    -- { localleader .. "rce", "<Cmd>cd $DB_CONNECTIONS_FILEPATH; sops --encrypt --in-place connections.yaml<Cr>", desc = "Encrypt DB config" },
    -- { localleader .. "rca", "<Cmd>edit $DB_CONNECTIONS_FILEPATH/connections.yaml;<Cr>", desc = "Edit DB config" },
    -- { localleader .. "rRf", <Plug>(DBUI_Redraw)", desc = "Redraw connections"}
  },
  markdown = {
    mode = { "n", "v" },
    { localleader .. "r", group = "Markdown" },
    { localleader .. "re", "<Cmd>FeMaco<Cr>", desc = "Code block edit" },
    { localleader .. "rr", "<Cmd>MarkdownPreview<Cr>", desc = "Markdown Preview" },
    { localleader .. "rt", "<Cmd>MarkdownPreviewToggle<Cr>", desc = "Markdown Preview Toggle" },
    { localleader .. "rx", "<Cmd>MarkdownPreviewStop<Cr>", desc = "Markdown Preview Stop" },
  },
  norg = {
    -- Neorg specific mapping
    -- https://github.com/nvim-neorg/neorg/wiki/Default-Keybinds#localleaderid
    mode = { "n", "v" },
    { localleader .. "<CR>", "<Plug>(neorg.esupports.hop.hop-link)", desc = "Open link" },
    { localleader .. "cm", "<Plug>(neorg.looking-glass.magnify-code-block)", desc = "Code Magnify" },

    { localleader .. "i", "", desc = "Insert date" },
    { localleader .. "im", "<Plug>(neorg.tempus.insert-date)", desc = "Insert Date" },

    { localleader .. "l", "", desc = "List actions" },
    { localleader .. "li", "<Plug>(neorg.pivot.list.invert)", desc = " List Invert " },
    { localleader .. "lt", "<Plug>(neorg.pivot.list.toggle)", desc = " List Toggle " },

    { localleader .. "t", "", desc = "GTD actions" },
    { localleader .. "t ", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", desc = "Task cycle" },
    { localleader .. "ta", "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)", desc = "Mark task as ambiguous" },
    { localleader .. "tc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", desc = "Mark task as cancelled " },
    { localleader .. "td", "<Plug>(neorg.qol.todo-items.todo.task-done)", desc = "Mark task as done " },
    { localleader .. "th", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", desc = "Mark task as hold " },
    { localleader .. "ti", "<Plug>(neorg.qol.todo-items.todo.task-important)", desc = "Mark task as important" },
    { localleader .. "tp", "<Plug>(neorg.qol.todo-items.todo.task-pending)", desc = "Mark task as pending" },
    { localleader .. "tr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)", desc = "Mark task as recurring" },
    { localleader .. "tu", "<Plug>(neorg.qol.todo-items.todo.task-undone)", desc = "Mark task as undone" },

    -- { localleader .. "m", "", desc = "Navigation mode" },
    { localleader .. "n", "", desc = "Notes" },
    { localleader .. "nn", "<Plug>(neorg.dirman.new-note)", desc = "New note" },

    {
      localleader .. "e",
      "<Cmd>exec 'Neorg export to-file /tmp/temp.md' | sleep 500m | tabe /tmp/temp.md<Cr>",
      desc = "Export",
    },
    -- Requires clipboard https://github.com/Slackadays/Clipboard
    {
      localleader .. "y",
      "<Cmd>exec 'Neorg export to-file /tmp/temp.md' | sleep 500m | !cat /tmp/temp.md | cb copy<Cr>",
      desc = "Copy as markdown",
    },
    { localleader .. "T", "", desc = "Toggle" },
    { localleader .. "Tc", ":Neorg toggle-concealer<CR>", desc = "Toggle concealing" },
  },
  ["*"] = {
    mode = { "n", "v" },
    { localleader .. "/", group = "Common mappings" },
    { localleader .. "/p", ":!opout %<CR>", desc = "Preview files" },
    { localleader .. "/c", ':exec ":w! | :vs | :te compiler % ".input("Enter args: ")<CR>', desc = "Compile" },
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
        wk.add(mappings)
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
  wk.add(leader_mappings)
  wk.add(visual_leader_mappings)
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
