local opt = vim.opt
local g = vim.g
local cmd = vim.cmd

-------------------------------------- cmds -----------------------------------------
cmd "syntax on"
cmd "filetype plugin indent on"

-------------------------------------- globals -----------------------------------------
g.mapleader = " " -- Space as leader key
g.maplocalleader = "," -- Comma as local leader key
g.matchparen_timeout = 20 -- Reducing the time out to avoid sluggishness
g.matchparen_insert_timeout = 20

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  g["loaded_" .. provider .. "_provider"] = 0
end

-------------------------------------- options ------------------------------------------
-- opt.iskeyword:remove "-" -- treat dash separated words as a word text object"
opt.formatoptions:remove "cro" -- Stop newline continution of comments

opt.hidden = true -- Required to keep multiple buffers open multiple buffers
opt.encoding = "utf-8" -- The encoding displayed
opt.pumheight = 10 -- Makes popup menu smaller
opt.fileencoding = "utf-8" -- The encoding written to file
opt.ruler = true -- Show the cursor position all the time
opt.cmdheight = 1 -- More space for displaying messages
opt.mouse:append "a" -- Enable your mouse
opt.conceallevel = 2 -- Helpful in hiding/replacing specific value with a cchar, using vim conceal feature
opt.tabstop = 2 -- Insert 2 spaces for a tab
opt.softtabstop = 2
opt.shiftwidth = 2 -- Change the number of space characters inserted for indentation
opt.splitbelow = true -- Horizontal splits will automatically be below
opt.splitright = true -- Vertical splits will automatically be to the right
opt.smarttab = true -- Makes tabbing smarter will realize you have 2 vs 4
opt.expandtab = true -- Converts tabs to spaces
opt.smartindent = true -- Makes indenting smart
opt.autoindent = true -- Good auto indent
-- opt.laststatus = 3                        -- Always display the status line, use global statusline
opt.cursorline = true -- Enable highlighting of the current line
opt.showtabline = 2 -- Always show tabs
opt.showmode = false -- We don't need to see things like -- INSERT -- anymore
opt.showcmd = false -- Prevent showing last command
opt.backup = false -- This is recommended by coc
opt.writebackup = false -- This is recommended by coc
-- Don't pass messages to |ins-completion-menu|., reduces status message, disable nvim intro
opt.shortmess:append "atFcsI"
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.updatetime = 250 -- Faster completion, interval for writing swap file to disk, also used by gitsigns
opt.timeoutlen = 500 -- By default timeoutlen is 1000 ms
opt.ttimeoutlen = 0 -- By default ttimeoutlen is 1000 ms
opt.clipboard = "unnamedplus" -- Copy paste between vim and everything else
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.statusline = "-" -- hide file name in statusline
opt.fillchars:append "vert:│" -- Fills vertical split with `|` symbol
opt.fillchars:append "stl:-" -- Fills horizontal split with `-` symbol
opt.fillchars:append "stlnc:-" -- Fills inactive horizontal split with `-` symbol
opt.wrap = false
opt.breakindent = true
opt.title = true
opt.number = false
opt.numberwidth = 2
opt.relativenumber = true
-- opt.colorcolumn="120"                   -- Handling this with smartcolumn plugin
opt.swapfile = false
opt.undofile = true
opt.scrolloff = 5
opt.fixendofline = false -- Avoid fixing new line end of file

opt.complete:append "kspell" -- Spell check
opt.spelllang = "en_us"

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- Directory setup
opt.undodir = "~/.cache/nvim/undo"
opt.directory = "~/.cache/nvim/swap"
opt.backupdir = "~/.cache/nvim/backup"
opt.viewdir = "~/.cache/nvim/view"

-------------------------------------- autocmds ------------------------------------------
local autocmd = vim.api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-------------------------------------- new-commands ------------------------------------------
local new_cmd = vim.api.nvim_create_user_command

new_cmd("SampleCommand", function()
  print "SampleCommand triggered"
end, {})

require("core.utils").load_mappings()
require "core.autocmds"
