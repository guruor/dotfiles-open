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
local smartcolumn_config = require("smartcolumn").setup({
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
-- indentLine
-- ----------------
vim.g.indentLine_char = '▏'
vim.g.indentLine_color_gui = '#363949'

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
