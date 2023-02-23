" Obsession and Prosession
let g:session_directory = session_directory
let g:prosession_dir = session_directory
let g:prosession_last_session_dir = session_directory

" vim-pydocstring
let g:pydocstring_doq_path = '~/.pyenv/versions/nvim/bin/doq'

" TagBar
let g:tagbar_width = 30
let g:tagbar_iconchars = ['↠', '↡']

" indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'


" Goyo
let g:goyo_width=125

" Colorscheme

lua << EOF
  vim.g.gruvbox_contrast_light = 'medium'
  vim.g.gruvbox_contrast_dark = 'medium'
  vim.g.gruvbox_invert_selection = 0
  vim.g.gruvbox_italic = 1
  vim.g.gruvbox_sign_column = 'bg0'

  -- Available values:   `'material'`, `'mix'`, `'original'`
  vim.g.gruvbox_material_foreground = 'material'
  -- Available values: 'hard', 'medium'(default), 'soft'
  vim.g.gruvbox_material_background = 'medium'
  vim.g.gruvbox_material_better_performance = 1
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_disable_italic_comment = 1
  vim.g.gruvbox_material_transparent_background = 0

  local home_dir=os.getenv("HOME")
  dark_mode_flag_file=home_dir .. '/.cache/dark-mode.off'
  local f=io.open(dark_mode_flag_file,"r")
  if f~=nil then
      io.close(f)
      vim.cmd('set background=light')
  else
      vim.cmd('set background=dark')
  end

  -- vim.cmd('colorscheme gruvbox')
  vim.cmd('colorscheme gruvbox-material')
  -- Setting colorscheme overriding laststatus, so needed to redeclare
  vim.opt.laststatus = 3
EOF
