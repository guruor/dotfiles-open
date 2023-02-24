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

" Common lua utils used by other plugins
Plug 'nvim-lua/plenary.nvim'

" Editor look and feel
Plug 'rktjmp/lush.nvim'
Plug 'npxbr/gruvbox.nvim'
Plug 'sainnhe/gruvbox-material'
Plug 'nvim-lualine/lualine.nvim'
Plug 'vimpostor/vim-tpipeline' " Merged vim statusline with tmux
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'romgrk/barbar.nvim'
Plug 'j-hui/fidget.nvim'

" Easy search, navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'jesseleite/vim-agriculture'
Plug 'folke/which-key.nvim'
Plug 'majutsushi/tagbar',           { 'on': 'TagbarToggle'      }
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'jvgrootveld/telescope-zoxide'
Plug 'kevinhwang91/nvim-bqf' " For better preview of quickfix buffers
Plug 'stevearc/dressing.nvim' " For improved vim.ui interfaces


" Git stuff
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tommcdo/vim-fubitive' " GBrowse bitbucket support
Plug 'shumphrey/fugitive-gitlab.vim' " Gitlab gitlab support
Plug 'tpope/vim-rhubarb' " GBrowse github support

" Syntax, formatting and auto-completion
Plug 'sheerun/vim-polyglot'

" Managing and installing LSP servers
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'folke/neodev.nvim',
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'bufbuild/vim-buf'

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'
Plug 'jbyuki/one-small-step-for-vimkind'
Plug 'mfussenegger/nvim-dap-python'
Plug 'lukas-reineke/lsp-format.nvim'
" Plug 'Pocco81/DAPInstall.nvim'

" Task runner
Plug 'stevearc/overseer.nvim'

Plug 'alvan/vim-closetag'
Plug 'Yggdroot/indentLine',         { 'on': 'IndentLinesToggle' }

" Additional Functionalities
Plug 'editorconfig/editorconfig-vim'
Plug 'mbbill/undotree',             { 'on': 'UndotreeToggle'   }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'tpope/vim-abolish' " easily search for, substitute, and abbreviate multiple variants of a word

" Session management plugins
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

" Better working environment
Plug 'junegunn/goyo.vim',           { 'on': 'Goyo' }
" Plug 'junegunn/limelight.vim',      { 'on': 'LimeLight!!'}
Plug 'junegunn/limelight.vim'

" Rest client
" Plug 'NTBBloodbath/rest.nvim'
" Plug 'teto/rest.nvim', { 'branch': 'always-send-string' }
Plug 'G0V1NDS/rest.nvim', { 'branch': 'response_body_stored' }

" DB query executer
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'kristijanhusak/vim-dadbod-ui'

" File navigator, uses LF file manager to navigate and change working
" directory
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'

" VimWiki for note management
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Snippet
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" Good to have
Plug 'ron89/thesaurus_query.vim'
Plug 'christoomey/vim-tmux-navigator' " Switch windows with C-[h,j,k,l,\], same for tmux panes
Plug 'NvChad/nvim-colorizer.lua' " Highlights color code or hash
Plug 'm4xshen/smartcolumn.nvim'





" Yet to explorer
" Plug 'tpope/vim-sensible'
" Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
" Plug 'vim-scripts/loremipsum'
" Plug 'metakirby5/codi.vim'
" Plug 'dkarter/bullets.vim'
" Plug 'junegunn/vim-easy-align',       { 'on': ['EasyAlign'] }
" Plugings from Luke smith's dotfiles, confirm if still needed

call plug#end()
