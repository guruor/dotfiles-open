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

colorscheme gruvbox
set background=dark
call v:lua.self_color_gruvbox_dark()
if !empty(glob("/tmp/dark-mode.off"))
    set background=light
    call v:lua.self_color_gruvbox_light()
endif

function MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let label =  bufname(buflist[winnr - 1])
  return fnamemodify(label, ":t")
endfunction

set tabline=%!MyTabLine()
