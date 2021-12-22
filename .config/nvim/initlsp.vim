"    ____      _ __        _
"   /  _/___  (_) /__   __(_)___ ___
"   / // __ \/ / __/ | / / / __ `__ \
" _/ // / / / / /__| |/ / / / / / / /
"/___/_/ /_/_/\__(_)___/_/_/ /_/ /_/

source $HOME/.config/nvim/init.vim
" go install github.com/mattn/efm-langserver@latest
" npm -g install pyright gopls bash-language-server typescript typescript-language-server vim-language-server vscode-json-languageserver prettier yaml-language-server sql-language-server vscode-html-languageserver-bin dockerfile-language-server-nodejs

" pip install mypy flake8 autopep8 isort black vim-vint debugpy proselint
" yay lua-format | yay luarocks (sudo luarocks install --server=https://luarocks.org/dev luaformatter)

" LSP related config
" source $HOME/.config/nvim/source/plug-conf/coc.vim
lua << EOF
    require("dbg")
    require("lsp")
EOF
