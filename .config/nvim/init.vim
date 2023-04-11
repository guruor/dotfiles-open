"    ____      _ __        _
"   /  _/___  (_) /__   __(_)___ ___
"   / // __ \/ / __/ | / / / __ `__ \
" _/ // / / / / /__| |/ / / / / / / /
"/___/_/ /_/_/\__(_)___/_/_/ /_/ /_/

source $HOME/.config/nvim/source/plugins.vim

lua << EOF
    require("core")
    require("conf/thesaurus")
    require("functions")
    require("whichkeyconf")
    require("statusline")
    require("snippets")
    require("cmpconf")
    require("treesitter")
    require("telescopeconf")
    require("fzfconf")
    require("rest")
    require("barbarconf")
    require("overseerconf")
    require('gitsignsconf')
    require("conf/colorscheme")
    require("conf/misc")
EOF

" Plugin config
source $HOME/.config/nvim/source/plug-conf/vimwiki.vim

if filereadable(system('echo -n "$HOME/.config/nvim/source/private/dadbods.vim"'))
    source $HOME/.config/nvim/source/private/dadbods.vim
endif
