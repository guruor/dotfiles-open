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
    require("conf/vimwiki")
    require("conf/misc")

  if vim.fn.filereadable(vim.fn.expand "$HOME" .. "/.config/nvim/lua/Private/plugins/configs/dadbod.lua") then
    require("Private/plugins/configs/dadbod").setup()
  end
EOF

