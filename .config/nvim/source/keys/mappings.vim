" g Leader key
	let mapleader=" "
	nnoremap <Space> <Nop>

" Better indenting
	vnoremap < <gv
	vnoremap > >gv

" Better nav for omnicomplete
	inoremap <expr> <c-j> ("\<C-n>")
	inoremap <expr> <c-k> ("\<C-p>")

" Better window navigation
	imap <C-h> <C-w>h
	imap <C-j> <C-w>j
	imap <C-k> <C-w>k
	imap <C-l> <C-w>l

" TAB in general mode will move to text buffer
	nnoremap <silent> <TAB> :tabnext<CR>

" SHIFT-TAB will go back
	nnoremap <silent> <S-TAB> :tabprevious<CR>

" Move selected line / block of text in visual mode
" shift + k to move up
" shift + j to move down
	xnoremap K :move '<-2<CR>gv-gv
	xnoremap J :move '>+1<CR>gv-gv

" Alternate way to save
	nnoremap <silent> <C-s> :w<CR>
" Alternate way to quit
	nnoremap <silent> <C-Q> :wq!<CR>
" Replace ex mode with gq
	map Q gq

" Use control-c instead of escape
	nnoremap <silent> <C-c> <Esc>

" <TAB>: completion.
	inoremap <silent> <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Use alt + hjkl to resize windows
	nnoremap <silent> <M-j>    :resize -2<CR>
	nnoremap <silent> <M-k>    :resize +2<CR>
	nnoremap <silent> <M-h>    :vertical resize -2<CR>
	nnoremap <silent> <M-l>    :vertical resize +2<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
