"    ____      _ __        _
"   /  _/___  (_) /__   __(_)___ ___
"   / // __ \/ / __/ | / / / __ `__ \
" _/ // / / / / /__| |/ / / / / / / /
"/___/_/ /_/_/\__(_)___/_/_/ /_/ /_/

source $HOME/.config/nvim/init.vim

" LSP related config
" source $HOME/.config/nvim/source/plug-conf/coc.vim
lua << EOF
    require("dbg")
    require("lsp")
EOF
