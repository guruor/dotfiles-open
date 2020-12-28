" Obsession and Prosession
let g:session_directory = session_directory
let g:prosession_dir = session_directory
let g:prosession_last_session_dir = session_directory

" Airline
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1
let g:airline_section_z = ' %{strftime("%-I:%M %p")}'
let g:airline_section_warning = ''
let g:airline#extensions#tagbar#flags = 'f'  " show full tag hierarchy
" let g:airline#extensions#tabline#enabled = 1

" vim-pydocstring
let g:pydocstring_doq_path = '~/.pyenv/versions/neovim/bin/doq'

" Ultisnips
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-x>"

" TagBar
let g:tagbar_width = 30
let g:tagbar_iconchars = ['↠', '↡']

" indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

" Limelight
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'
" highlight line
let g:limelight_bop = '^.*$'
" let g:limelight_eop = '\n'
let g:limelight_paragraph_span = 0

" Goyo
let g:goyo_width=125
