set rtp +=~/.config/nvim
set rtp +=~/.config/vim

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall

    " Setting up python virtual environment for neovim
    if ! isdirectory(system('echo -n "${HOME}/.pyenv/versions/nvim"'))
        echo "Creating virtual environment ..."
        " Check if python or pip needs to be installed
        " silent !sudo pacman -S words --noconfirm
        silent !pyenv install 3.10.0 || true
        silent !pyenv virtualenv 3.10.0 nvim || true
        silent !pyenv virtualenv 3.10.0 debugpy || true " Creating a virtualenv for debugpy for python debugging
        silent !~/.pyenv/versions/nvim/bin/python -m pip install neovim pynvim
        silent !~/.pyenv/versions/debugpy/bin/python -m pip install debugpy
    endif
endif

""" Vim-Plug
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

" Editor look and feel
Plug 'rktjmp/lush.nvim'
Plug 'npxbr/gruvbox.nvim'
Plug 'glepnir/galaxyline.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'romgrk/barbar.nvim'

" Easy search, navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jesseleite/vim-agriculture'
Plug 'folke/which-key.nvim'
Plug 'majutsushi/tagbar',           { 'on': 'TagbarToggle'      }

" Git stuff
Plug 'tpope/vim-fugitive'

" Syntax, formatting and auto-completion
Plug 'sheerun/vim-polyglot'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'
Plug 'jbyuki/one-small-step-for-vimkind'
Plug 'mfussenegger/nvim-dap-python'
Plug 'lukas-reineke/lsp-format.nvim'
" Plug 'Pocco81/DAPInstall.nvim'

Plug 'alvan/vim-closetag'
Plug 'Yggdroot/indentLine',         { 'on': 'IndentLinesToggle' }

" Additional Functionalities
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
" Plug 'junegunn/limelight.vim',      { 'on': 'LimeLight!!'}
Plug 'junegunn/limelight.vim'

" Rest client
Plug 'nvim-lua/plenary.nvim'
" Plug 'NTBBloodbath/rest.nvim'
" Plug 'teto/rest.nvim', { 'branch': 'always-send-string' }
Plug 'G0V1NDS/rest.nvim', { 'branch': 'response_body_stored' }

" DB query executer
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'kristijanhusak/vim-dadbod-ui'

" Good to have
Plug 'vimwiki/vimwiki'
Plug 'ron89/thesaurus_query.vim'

" Yet to explorer
" Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-abolish'
" Plug 'chrisbra/Colorizer'
" Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
" Plug 'vim-scripts/loremipsum'
" Plug 'metakirby5/codi.vim'
" Plug 'dkarter/bullets.vim'
" Plug 'junegunn/vim-easy-align',       { 'on': ['EasyAlign'] }
" Plugings from Luke smith's dotfiles, confirm if still needed

call plug#end()
