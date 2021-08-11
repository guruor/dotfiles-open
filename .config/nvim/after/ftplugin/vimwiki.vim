inoremap <expr><silent><buffer> <CR> pumvisible() ? compe#confirm('<CR>') : '<C-]><Esc>:VimwikiReturn 1 5<CR>'

set commentstring=<!--\ %s\ -->
