"    ____      _ __        _
"   /  _/___  (_) /__   __(_)___ ___
"   / // __ \/ / __/ | / / / __ `__ \
" _/ // / / / / /__| |/ / / / / / / /
"/___/_/ /_/_/\__(_)___/_/_/ /_/ /_/

source $HOME/.config/nvim/source/plugins.vim
source $HOME/.config/nvim/source/general/settings.vim
source $HOME/.config/nvim/source/general/functions.vim
source $HOME/.config/nvim/source/keys/mappings.vim

lua << EOF
    require("whichkeyconf")
    require("statusline")
    require("gruvbox-statusline")
    require("compeconf")
    require("treesitter")
    require("rest")
EOF

" Plugin config
source $HOME/.config/nvim/source/plug-conf/fzf.vim
source $HOME/.config/nvim/source/plug-conf/misc.vim
