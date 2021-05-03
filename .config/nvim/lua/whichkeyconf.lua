local wk = require("which-key")

local leader = "<Space>"
local localleader = ","

wk.register({
    ["<Tab>"] = {":tabnext<CR>", "Jump to next tab"},
    ["0"] = {":tabp<CR>", "Jump to previous active tab"},
    ["1"] = {"1gt", "which_key_ignore"},
    ["2"] = {"2gt", "which_key_ignore"},
    ["3"] = {"3gt", "which_key_ignore"},
    ["4"] = {"4gt", "which_key_ignore"},
    ["5"] = {"5gt", "which_key_ignore"},
    ["6"] = {"6gt", "which_key_ignore"},
    ["7"] = {"7gt", "which_key_ignore"},
    ["8"] = {"8gt", "which_key_ignore"},
    ["9"] = {"9gt", "which_key_ignore"},
    ["u"] = {":update<CR>", "Save file"},
    ["d"] = {":bd<CR>", "Delete buffer"},
    ["q"] = {":q<CR>", "Quit"},
    ["x"] = {":q!<CR>", "Close without saving"},
    ["Q"] = {":qa!<CR>", "Quit all"}
}, {prefix = localleader})

wk.register({
    ["\\"] = {":TagbarToggle<CR>", "Toggle tagbar"},
    ["/"] = {":'<,'>call Comment()<CR>", "Comment"},
    ["C"] = {":Code!!<CR>", "Virtual REPL"},
    ["p"] = {":Files<CR>", "Find files"},
    ["P"] = {":!opout <c-r>%<CR><CR>", "Preview files"},
    ["f"] = {":Rg<CR>", "Find text"},
    ["_"] = {"<C-W>s", "Split below"},
    ["|"] = {"<C-W>v", "Split right"},
    ["c"] = {":w! | !compiler \"<c-r>%\"<CR>", "Compile"},
    ["X"] = {":split | term<CR>", "Terminal"},
    ["z"] = {"Goyo", "Goyo"},
    ["."] = {":tabnew $MYVIMRC<CR>", "Open Init"},
    ["R"] = {":source $MYVIMRC<CR>", "Reload Init"},
    ["U"] = {":UndotreeToggle<CR>", "Undo Tree"},
    [" "] = {":noh<CR>", "No Highlight"},
    ["L"] = {":Limelight<CR>", "Limelight activate"}
}, {prefix = leader})

wk.register({
    ["/"] = {":'<,'>call Comment()<CR>", "Comment"},
}, {prefix = leader, mode = 'v'})

wk.register({
    g = {
        name = 'Git',
        ["b"] = {":Git blame<CR>", "Blame"},
        ["B"] = {":GBrowse<CR>", "Browse"},
        ["c"] = {":Git commit<CR>", "Commit"},
        ["d"] = {":Git diff<CR>", "Diff"},
        ["D"] = {":Gdiffsplit<CR>", "Diff split"},
        ["g"] = {":GGrep<CR>", "Grep"},
        ["s"] = {":Git<CR>", "Status"},
        ["l"] = {":Git log<CR>", "Log"},
        ["p"] = {":Git push<CR>", "Push"},
        ["P"] = {":Git pull<CR>", "Pull"}
    }
}, {prefix = leader})

wk.register({
    l = {
        name = 'LSP',
        ["f"] = {":update | lua require'lsp.formatting'.format()<CR>", "Format"},
        ["d"] = {"", "Diagnostic"},
        ["n"] = {"", "Next diagnostic"},
        ["N"] = {"", "Next error"},
        ["p"] = {"", "Prev diagnostic"},
        ["p"] = {"", "Prev error"},
        ["q"] = {"", "Quick fix"},
        ["r"] = {"", "Rename"},
        ["R"] = {"", "References"}
    }
}, {prefix = leader})

wk.register({
    t = {
        name = 'Toggle',
        ["n"] = {":set nonumber!<CR>", "Line numbers"},
        ["r"] = {":set norelativenumber!<CR>", "Relative line numbers"},
        ["w"] = {":set wrap!<CR>", "Word wrap"},
        ["c"] = {":ColorizerToggle<CR>", "Colorizer"},
        ["l"] = {":Limelight!!<CR>", "Limelight"},
        ["i"] = {":IndentLinesToggle<CR>", "Indent lines"},
        ["u"] = {":UndotreeToggle<CR>", "Undo Tree"},
        ["h"] = {":call ToggleHiddenAll()<CR>", "Hide"}
    }
}, {prefix = leader})

wk.register({
    m = {
        name = 'Macro',
        ["j"] = {":'<,'>!jq .", "Format selection as json"},
        ["n"] = {":%s/\\n/\r/g", "Replace \n with newline charFormat sqlalchemy query from logs"},
        ["{"] = {":%s/\\%V{/{{/g | %s/\\%V}/}}/g", "Replace braces with double braces for multiline formatted string"},
        ["\""] = {":%s/'/\"/g", "Replace ' with \""},
        ["\\"] = {":%s/\"/'/g", "Replace \" with '"}
    }
}, {prefix = leader})
