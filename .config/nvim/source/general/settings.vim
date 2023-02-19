
" set iskeyword+=-                        " treat dash separated words as a word text object"
set formatoptions-=cro                  " Stop newline continution of comments

syntax enable                           " Enables syntax highlighing

set hidden                              " Required to keep multiple buffers open multiple buffers
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler                               " Show the cursor position all the time
set cmdheight=1                         " More space for displaying messages
set mouse+=a                            " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set conceallevel=2                      " Helpful in hiding/replacing specific value with a cchar, using vim conceal feature
set tabstop=4                           " Insert 2 spaces for a tab
set softtabstop=4
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set laststatus=3                        " Always display the status line, use global statusline
set cursorline                          " Enable highlighting of the current line
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
set noswapfile
set undofile
set scrolloff=5

" No highlight for window separator, userful with global statusline
highlight WinSeparator guibg=None

" Setting colorschema after setting up background
set t_Co=256                            " Support 256 colors
set termguicolors

""" Coloring
" highlight Pmenu guibg=white guifg=black gui=bold
" highlight Comment gui=bold
" highlight Normal gui=none
" highlight NonText guibg=none

" Transparent Background (For i3 and compton)
" highlight Normal guibg=NONE ctermbg=NONE
" highlight LineNr guibg=NONE ctermbg=NONE

" Reducing the time out to avoid sluggishness
let g:matchparen_timeout = 20
let g:matchparen_insert_timeout = 20

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noselect

" Spell check
set complete+=kspell
set spell spelllang=en_us

if ! isdirectory(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus"'))
    echo "Downloading dictionary ..."
    silent !sudo pacman -S words --noconfirm
    echo "Downloading thesaurus ..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus/
    silent !curl "https://www.gutenberg.org/files/3202/files/mthesaur.txt" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus/mthesaur.txt

    " Other alternatives
    " silent !curl "https://raw.githubusercontent.com/words/moby/master/words.txt" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus/words.txt
    " silent !curl "https://raw.githubusercontent.com/moshahmed/vim/master/thesaurus/thesaurii.txt" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus/thesaurii.txt
endif

set thesaurus='~/.config/nvim/thesaurus/mthesaur.txt'
let g:tq_mthesaur_file="~/.config/nvim/thesaurus/mthesaur.txt"
let tq_enabled_backends=["openoffice_en", "datamuse_com", "mthesaur_txt"]
set dictionary='/usr/share/dict/words'

" Preventing thesaurus_query from binding any keys, will map custom keys using whichkey
let g:tq_map_keys=0

""" netrw settings
let g:netrw_banner=0
let g:netrw_browse_split=2
let g:netrw_winsize=25

set undodir=~/.cache/nvim/undo
set directory=~/.cache/nvim/swap
set backupdir=~/.cache/nvim/backup
set viewdir=~/.cache/nvim/view
" Sesstion directory
let session_directory='~/.cache/nvim/session/'

""" Python3 VirtualEnv
let g:python3_host_prog = expand('~/.pyenv/versions/nvim/bin/python')

""" Filetype-Specific Configurations
filetype plugin indent on

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Setting default height and with for floaterm
let g:floaterm_width = 0.6
let g:floaterm_height = 0.6

" Disabling default mapping for lf.vim
let g:lf_map_keys = 0
let g:lf_width = 0.75
let g:lf_height = 0.75
let g:NERDTreeHijackNetrw = 0 " Add this line if you use NERDTree
let g:lf_replace_netrw = 1 " Open lf when vim opens a directory
