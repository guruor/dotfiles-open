
let g:startify_custom_header = [
            \ '      _____  _____      ___ _   _ _____   _____',
            \ '     / ____|/ _ \ \    / / | \ | |  __ \ / ____|',
            \ '    | |  __| | | \ \  / /| |  \| | |  | | (___',
            \ '    | | |_ | | | |\ \/ / | | . ` | |  | |\___ \',
            \ '    | |__| | |_| | \  /  |_| |\  | |__| |____) |',
            \ '     \_____|\___/   \/   (_)_| \_|_____/|_____/'
            \]

let g:startify_session_dir = session_directory


let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Files']                        },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']                     },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']                    },
          \ ]


let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1

let g:webdevicons_enable_startify = 1

function! StartifyEntryFormat()
        return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction

let g:startify_bookmarks = [
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.config/zsh/.zshrc' },
            \ '~/Workspace/up/atlas_server',
            \ '~/Workspace/up/codex',
            \ ]

let g:startify_enable_special = 0
