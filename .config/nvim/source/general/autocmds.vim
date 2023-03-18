" Toggle relative number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Creates directory when creating new file on a path which doesn't exist
augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END

" Disabling syntax highlighting for larger files
    autocmd Filetype * if getfsize(@%) > 1000000 | setlocal syntax=OFF | setlocal foldmethod=manual | endif
" Filetype autocmds
    autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
" Markdown and Journal
    autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType journal setlocal shiftwidth=2 tabstop=2 softtabstop=2
" Changing commentstring for filetypes
    autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
    autocmd FileType http setlocal commentstring=#\ %s
" Enabling spell check for gitcommit
    autocmd FileType gitcommit setlocal spell

" Using different indentation pattern for Makefile
    autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

"File types specific mappings
" Vim dadbod dbui, mappings
    autocmd FileType dbui nmap <buffer> o <Plug>(DBUI_SelectLine)
    autocmd FileType dbui nmap <buffer> S <Plug>(DBUI_SelectLineVsplit)
    autocmd FileType dbui nmap <buffer> d <Plug>(DBUI_DeleteLine)
    autocmd FileType dbui nmap <buffer> R <Plug>(DBUI_Redraw)
    autocmd FileType dbui nmap <buffer> A <Plug>(DBUI_AddConnection)
    autocmd FileType dbui nmap <buffer> H <Plug>(DBUI_ToggleDetails)
" Vim dadbod dbout, mappings
    autocmd FileType dbout nmap <buffer> <C-]> <Plug>(DBUI_JumpToForeignKey)
    autocmd FileType dbout nmap <buffer> vic <Plug>(DBUI_YankCellValue)
    autocmd FileType dbout nmap <buffer> yh <Plug>(DBUI_YankHeader)
    autocmd FileType dbout nmap <buffer> <Leader>R <Plug>(DBUI_ToggleResultLayout)
" Django template specific mappings
    autocmd FileType htmldjango inoremap {{ {{  }}<left><left><left>
    autocmd FileType htmldjango inoremap {% {%  %}<left><left><left>
    autocmd FileType htmldjango inoremap {# {#  #}<left><left><left>
" Allowing opening of quick fix entries in new tab
    autocmd FileType qf nnoremap <buffer> <Enter> <C-W><Enter><C-W>T


" Opening terminal in insert mode
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd TermOpen * startinsert

" Enable folding
	autocmd BufReadPre * setlocal foldmethod=indent
	autocmd BufReadPre * setlocal foldlevel=1
    autocmd BufEnter *.md setlocal foldexpr=MarkdownLevel()
    autocmd BufEnter *.md setlocal foldmethod=expr
    autocmd BufEnter *.http setlocal foldlevel=0

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Auto detect dadbod connection for the file
	" autocmd BufRead,BufNewFile $DADBOD_DB_QUERIES_PATH/**/*.sql :exec 'DBUIFindBuffer' | DBUIToggle
	autocmd BufRead,BufNewFile $DB_QUERIES_PATH/**/*.sql :lua ChooseDBUIConnectionOptional()
	" autocmd BufRead,BufNewFile $DADBOD_DB_QUERIES_PATH/**/*.sql :lua ChooseDBUIConnectionOptional()
" Detect file type for tunnel-config file
	autocmd BufRead,BufNewFile $HOME/voidrice/Private/.config/.ssh/tunnel-config :setlocal filetype=sshconfig

" Detect file type for env files for rest-nvim
	autocmd BufRead,BufNewFile $REST_NVIM_COLLECTION_PATH/envs/* :setlocal filetype=sh

" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile xresources,xdefaults setlocal filetype=xdefaults

" Markdown and doc file related autocmds
	autocmd BufRead,BufNewFile *.md  setlocal filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man setlocal filetype=groff
	autocmd BufRead,BufNewFile *.tex setlocal filetype=tex
    autocmd BufRead,BufNewFile *.md setlocal spell

" Auto show diagnostics for a line when curson is on the line
    " Show diagnostic hover after 'updatetime' and don't steal focus
    " autocmd CursorHold * lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })
    " autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()


" Automatically deletes all trailing whitespace and newlines at end of file on save.
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !$HOME/.local/bin/shortcuts
" Auto reloads xresources settings
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost $HOME/.local/src/dwmblocks/config.h !cd $HOME/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }
" Recompile dwm on config edit.
	autocmd BufWritePost $HOME/.local/src/dwm/config.h !cd $HOME/.local/src/dwm/; sudo make install && kill -HUP $(pgrep -u $USER "\bdwm$")
" Restart yabai when yabai config is changed
	" autocmd BufWritePost $HOME/voidrice/.config/yabai/yabairc !brew services restart yabai; killall Dock
" Restart skhd when skhd config is changed
	" autocmd BufWritePost $HOME/voidrice/.config/skhd/skhdrc !brew services restart skhd;


" Storing last visited tab
    autocmd TabLeave * let g:lasttab = tabpagenr()

" Stops insert mode for terminal window
    autocmd BufLeave term://* stopinsert
    autocmd BufLeave *  call CleanNoNameEmptyBuffers()

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %



" Autogroups
""""""""""""

" Save and restore folds
" set viewoptions-=options
" augroup remember_folds
    " autocmd!
    " autocmd BufWinLeave *.* if &ft !=# 'help' || &ft !=# 'fugitiveblame' | mkview | endif
    " autocmd BufWinEnter *.* if &ft !=# 'help' || &ft !=# 'fugitiveblame' | silent! loadview | endif
" augroup END

" Vimwiki diary template
autocmd BufNewFile $VIMWIKI_DIR/**/diary/*.md
      \ call append(0,[
      \ "# Notes for " . split(expand('%:r'),'/')[-1], "",
      \ "## TODOs", "",
      \ "- [✗] ", "",
      \ "## Callouts", "",
      \ "- "])
