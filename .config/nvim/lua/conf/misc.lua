local home_dir=os.getenv("HOME")

-- ----------------
-- Comment settings
-- ----------------
require('Comment').setup()

-- ----------------
-- Colorizer settings
-- ----------------
require 'colorizer'.setup()

-- ----------------
-- smartcolumn settings
-- ----------------
require("smartcolumn").setup({
   colorcolumn = 120,
   disabled_filetypes = { "help", "text", "markdown" },
})

-- ----------------
-- Obsession and Prosession
-- ----------------
-- Sesstion directory
local session_directory = home_dir .. '/.cache/nvim/session/'
vim.g.session_directory = session_directory
vim.g.prosession_dir = session_directory
vim.g.prosession_last_session_dir = session_directory

-- ----------------
-- vim-pydocstring
-- ----------------
vim.g.pydocstring_doq_path = home_dir .. '/.pyenv/versions/nvim/bin/doq'

-- ----------------
-- Python3 VirtualEnv
-- ----------------
vim.g.python3_host_prog = home_dir .. '/.pyenv/versions/nvim/bin/python'

-- ----------------
-- gruvbox settings
-- ----------------
vim.g.gruvbox_contrast_light = 'medium'
vim.g.gruvbox_contrast_dark = 'medium'
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_italic = 1
vim.g.gruvbox_sign_column = 'bg0'

-- ----------------
-- gruvbox_material settings
-- ----------------
-- Available values:   `'material'`, `'mix'`, `'original'`
vim.g.gruvbox_material_foreground = 'material'
-- Available values: 'hard', 'medium'(default), 'soft'
vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_disable_italic_comment = 1
vim.g.gruvbox_material_transparent_background = 0


-- ----------------
-- TagBar
-- ----------------
vim.g.tagbar_width = 30
vim.g.tagbar_iconchars = {'↠', '↡'}

-- ----------------
-- Goyo
-- ----------------
vim.g.goyo_width = 125

-- ----------------
-- TPipeLine
-- ----------------
-- Avoid duplicate statusline in case of config reload
vim.fn['tpipeline#state#reload']()

-- ----------------
-- Floaterm
-- ----------------
-- Setting default height and with for floaterm
vim.g.floaterm_width = 0.6
vim.g.floaterm_height = 0.6

-- ----------------
-- lf.vim
-- ----------------
vim.g.lf_map_keys = 0
vim.g.lf_width = 0.75
vim.g.lf_height = 0.75
vim.g.NERDTreeHijackNetrw = 0 --[[ Add this line if you use NERDTree ]]
vim.g.lf_replace_netrw = 1 --[[ Open lf when vim opens a directory ]]

-- ----------------
-- netrw
-- ----------------
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 2
vim.g.netrw_winsize = 25

-- ----------------
-- vim-better-whitespace
-- ----------------
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1
vim.g.strip_only_modified_lines = 1
vim.g.strip_whitespace_confirm = 0
-- vim.g.better_whitespace_ctermcolor='grey'
vim.g.better_whitespace_guicolor='#3c3836'

-- ----------------
-- indent-blankline
-- -- ----------------
vim.opt.list = true
vim.opt.listchars:append "tab:»-"
vim.opt.listchars:append "trail:⋅"
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
vim.g.indent_blankline_use_treesitter = true
require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = false,
    show_end_of_line = true,
    space_char_blankline = " ",
}

-- ----------------
-- nvim-FeMaco.lua
-- -- ----------------
require("femaco").setup()
