
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

""" Vim-Plug
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

" Editor look and feel
Plug 'morhetz/gruvbox'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

" Easy search, navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'majutsushi/tagbar',           { 'on': 'TagbarToggle'      }

" Git stuff
Plug 'tpope/vim-fugitive'

" Syntax, formatting and auto-completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'Yggdroot/indentLine',         { 'on': 'IndentLinesToggle' }

" Additional Functionalities
Plug 'mhinz/vim-startify'
Plug 'editorconfig/editorconfig-vim'
Plug 'mbbill/undotree',             { 'on': 'UndotreeToggle'   }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary',        { 'on': 'Commentary' }

" Session management plugins
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

" Better working environment
Plug 'junegunn/goyo.vim',           { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim',      { 'on': 'LimeLight!!'}

" Yet to explorer
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-abolish'
Plug 'sheerun/vim-polyglot'
Plug 'chrisbra/Colorizer'
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
Plug 'vim-scripts/loremipsum'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'metakirby5/codi.vim'
Plug 'dkarter/bullets.vim'
Plug 'junegunn/vim-easy-align',       { 'on': ['EasyAlign'] }
" Plugings from Luke smith's dotfiles, confirm if still needed
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'

" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'


call plug#end()
