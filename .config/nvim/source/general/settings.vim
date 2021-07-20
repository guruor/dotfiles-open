
" set iskeyword+=-                        " treat dash separated words as a word text object"
set formatoptions-=cro                  " Stop newline continution of comments

syntax enable                           " Enables syntax highlighing
colorscheme gruvbox

set hidden                              " Required to keep multiple buffers open multiple buffers
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler                               " Show the cursor position all the time
set cmdheight=1                         " More space for displaying messages
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=4                           " Insert 2 spaces for a tab
set softtabstop=4
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set laststatus=2                        " Always display the status line
set cursorline                          " Enable highlighting of the current line
set background=dark                     " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set noshowcmd                           " Prvent showing last command
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set shortmess+=atFc                     " Don't pass messages to |ins-completion-menu|., reduces status message
set signcolumn=yes                      " Always show the signcolumn, otherwise it would shift the text each time
set updatetime=250                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set ttimeoutlen=0                      " By default ttimeoutlen is 1000 ms
set clipboard=unnamedplus               " Copy paste between vim and everything else
set incsearch
set ignorecase
set smartcase
set hlsearch
" set list listchars=trail:»,tab:»-
set fillchars+=vert:\
set nowrap
set breakindent
set title
set number relativenumber
set colorcolumn=120
set termguicolors
set noswapfile
set undofile
set scrolloff=5
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noselect

""" netrw settings
let g:netrw_banner=0
let g:netrw_browse_split=2
let g:netrw_winsize=25

set undodir=~/.cache/vim/undo
set directory=~/.cache/vim/swap
set backupdir=~/.cache/vim/backup
set viewdir=~/.cache/vim/view
" Sesstion directory
let session_directory='~/.cache/vim/session/'

""" Python3 VirtualEnv
let g:python3_host_prog = expand('~/.pyenv/versions/nvim/bin/python')
all
""" Coloring
highlight Pmenu guibg=white guifg=black gui=bold
highlight Comment gui=bold
highlight Normal gui=none
highlight NonText guibg=none

" Transparent Background (For i3 and compton)
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE

""" Filetype-Specific Configurations
filetype plugin indent on

" HTML, XML, Jinja
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango inoremap {{ {{  }}<left><left><left>
autocmd FileType htmldjango inoremap {% {%  %}<left><left><left>
autocmd FileType htmldjango inoremap {# {#  #}<left><left><left>

" Markdown and Journal
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType journal setlocal shiftwidth=2 tabstop=2 softtabstop=2

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd TermOpen * startinsert

autocmd BufLeave term://* stopinsert


" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save.
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }
	autocmd BufWritePost ~/.local/src/dwm/config.h !cd ~/.local/src/dwm/; sudo make install && kill -HUP $(pgrep -u $USER "\bdwm$")

" Auto show diagnostics for a line when curson is on the line
    " Show diagnostic hover after 'updatetime' and don't steal focus
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})
    autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what "Multiple Wikis
" https://opensource.com/article/18/6/vimwiki-gitlab-notes
"
" Use wiki names via :h vimwiki-option-name
" Clone off a default https://github.com/vimwiki/vimwiki/issues/365
    let myWikiDefault = {}
    let myWikiDefault.syntax = 'markdown'
    let myWikiDefault.ext = 'md'

    let myWikiPersonal = copy(myWikiDefault)
    let myWikiPersonal.path = $VIMWIKI_DIR_PERSONAL . "/wiki/"
    let myWikiPersonal.name = 'myWikiPersonal'

    let myWikiWork = copy(myWikiDefault)
    let myWikiWork.path = $VIMWIKI_DIR_WORK . "/wiki/"
    let myWikiWork.name = 'myWikiWork'

    let g:vimwiki_list = [myWikiWork, myWikiPersonal]
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	autocmd BufRead,BufNewFile *.md  set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex


" Disabling syntax highlighting for larger files
    autocmd Filetype * if getfsize(@%) > 1000000 | setlocal syntax=OFF | endif

" Storing last visited tab
    au TabLeave * let g:lasttab = tabpagenr()
