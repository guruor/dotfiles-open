" Obsession and Prosession
let g:session_directory = session_directory
let g:prosession_dir = session_directory
let g:prosession_last_session_dir = session_directory

" vim-pydocstring
let g:pydocstring_doq_path = '~/.pyenv/versions/neovim/bin/doq'

" Ultisnips
let g:UltiSnipsSnippetDirectories=["ultisnips"]
let g:UltiSnipsExpandTrigger = "<C-space>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

" TagBar
let g:tagbar_width = 30
let g:tagbar_iconchars = ['↠', '↡']

" indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'


" Goyo
let g:goyo_width=125


set background=dark
call v:lua.self_color_gruvbox_dark()
if !empty(glob("/tmp/dark-mode.off"))
    set background=light
    call v:lua.self_color_gruvbox_light()
endif
