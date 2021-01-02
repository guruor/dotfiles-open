" g Leader key
	let mapleader=" "
	let localleader=","

" Better indenting
	vnoremap < <gv
	vnoremap > >gv

" Better nav for omnicomplete
	inoremap <expr> <c-j> ("\<C-n>")
	inoremap <expr> <c-k> ("\<C-p>")

" Alternate way to save
	nnoremap <silent> <C-s> :w<CR>
" Alternate way to quit
	nnoremap <silent> <C-Q> :wq!<CR>
" Alternate way to escape
	nnoremap <silent> <C-c> <Esc>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Move selected line / block of text in visual mode
" shift + k to move up
" shift + j to move down
    xnoremap K :move '<-2<CR>gv-gv
    xnoremap J :move '>+1<CR>gv-gv

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
