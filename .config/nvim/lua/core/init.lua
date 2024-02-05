local opt = vim.opt
local g = vim.g
local cmd = vim.cmd

local home_dir = vim.fn.expand "$HOME"
vim.opt.rtp:prepend(home_dir .. "/.config/vim")
vim.opt.rtp:prepend(home_dir .. "/.config/nvim")

-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

-------------------------------------- cmds -----------------------------------------
cmd "syntax on"
cmd "filetype plugin indent on"

-------------------------------------- globals -----------------------------------------
g.mapleader = " " -- Space as leader key
g.maplocalleader = "\\" -- Comma as local leader key

-- Setting default border for nvim_open_win
-- As of now there is no option to set default border
-- Border color can be handled with highlight group `FloatBorder`
--https://github.com/neovim/neovim/issues/20202
-- local border_style = "curved"
local border_style = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
g.border_style = border_style
-- disable some default providers
for _, provider in ipairs { "node", "perl", "ruby" } do
  g["loaded_" .. provider .. "_provider"] = 0
end

-- We can use https://github.com/linux-cultist/venv-selector.nvim for dynamic choice
g.python3_host_prog = home_dir .. "/.pyenv/versions/nvim/bin/python"

-- netrw
g.netrw_banner = 0
g.netrw_browse_split = 2
g.netrw_winsize = 25

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
opt.signcolumn = "yes:1" -- Always show the signcolumn, otherwise it would shift the text each time
opt.updatetime = 250 -- Faster completion, interval for writing swap file to disk, also used by gitsigns
opt.timeoutlen = 500 -- By default timeoutlen is 1000 ms
opt.ttimeoutlen = 0 -- By default ttimeoutlen is 1000 ms
opt.clipboard = "unnamedplus" -- Copy paste between vim and everything else
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.statusline = "┈" -- hide file name in statusline
opt.fillchars:append "vert:┊" -- Fills vertical split with `|` symbol
opt.fillchars:append "stl:┈" -- Fills horizontal split with `-` symbol
opt.fillchars:append "stlnc:┄" -- Fills inactive horizontal split with `-` symbol
opt.wrap = false
opt.breakindent = true
opt.title = true
opt.number = true
opt.numberwidth = 3
opt.relativenumber = true
-- opt.colorcolumn="120"                   -- Handling this with smartcolumn plugin
opt.swapfile = false
opt.undofile = true
opt.scrolloff = 5
opt.fixendofline = false -- Avoid fixing new line end of file
opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

opt.complete:append "kspell" -- Spell check
opt.spelllang = "en_us"

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- Directory setup
opt.undodir = home_dir .. "/.cache/nvim/undo"
opt.directory = home_dir .. "/.cache/nvim/swap"
opt.backupdir = home_dir .. "/.cache/nvim/backup"
opt.viewdir = home_dir .. "/.cache/nvim/view"

-- listchars setup
opt.list = true
opt.listchars:append "tab:»-"
opt.listchars:append "trail:⋅"
opt.listchars:append "space:⋅"
opt.listchars:append "eol:↴"

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

new_cmd("DiffviewToggle", function(e)
  local view = require("diffview.lib").get_current_view()

  if view then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen " .. e.args)
  end
end, { nargs = "*" })

new_cmd("SampleCommand", function()
  print "SampleCommand triggered"
end, {})

require("core.utils").load_mappings()
require "core.functions"
require "core.autocmds"
