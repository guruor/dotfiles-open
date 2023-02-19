" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction

function! ToggleBackground(...)
    if a:0 == 0
        let l:new_bg = &background == "light"? "dark": "light"
    else
        let l:new_bg = a:1
    endif

    let &background=l:new_bg
    if l:new_bg == "dark"
        call v:lua.self_color_gruvbox_dark()
    else
        call v:lua.self_color_gruvbox_light()
    endif
endfunction

function ProfileStart()
    :set verbose=9
    :set verbosefile=/tmp/verbose.txt
    " :verbose {some action}
    :set noshowmatch
    :set norelativenumber
    :set nocursorline
    :set nocursorcolumn
    :set syntax=off
    :set re=1
    :LspStop
    " :NoMatchParen
    " let g:loaded_matchparen=1
    " call FuckThatMatchParen()
    :profile start /tmp/profile.log
    :profile func *
    :profile file *
endfunction


function ProfileStop()
     :profile stop
     :q!
endfunction

function! CleanNoNameEmptyBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0 && (getbufline(v:val, 1, "$") == [""])')
    if !empty(buffers)
        exe 'bd '.join(buffers, ' ')
    endif
endfunction

function MarkdownLevel()
    let h = matchstr(getline(v:lnum), '^#\+')
    if empty(h)
        return "="
    else
        return ">" . len(h)
    endif
endfunction
