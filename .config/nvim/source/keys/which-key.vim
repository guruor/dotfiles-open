" Vim Which Key bindings
" Map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :silent <c-u> :silent WhichKey  ','<CR>
vnoremap <silent> <localleader> :silent <c-u> :silent WhichKeyVisual  ','<CR>

" No search highlight
	nnoremap <silent> <leader><Space> :noh<CR>

" " Trigger custom method comment defined in functions.vim
" 	vnoremap <silent> <space>/ :call Comment()

" Create map to add keys to
let g:which_key_map =  {}
let g:which_key_local_map =  {}
" Define a separator
let g:which_key_sep = '→'


" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler


" Single local leader mappings, mostly will cover current tab and buffer related operations
let g:which_key_local_map['<Tab>'] = [ ':tabnext'						  , 'Jump to next tab' ]
let g:which_key_local_map['1'] = [ '1gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['2'] = [ '2gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['3'] = [ '3gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['4'] = [ '4gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['5'] = [ '5gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['6'] = [ '6gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['7'] = [ '7gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['8'] = [ '8gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['9'] = [ '9gt'								  , 'which_key_ignore' ]
let g:which_key_local_map['0'] = [ ':tabp'							      , 'Jump to previous active tab' ]
let g:which_key_local_map['w'] = [ 'w'							          , 'write' ]
let g:which_key_local_map['x'] = [ ':q!'						          , 'Close without save' ]
let g:which_key_local_map['q'] = [ 'q'                                    , 'quit' ]
let g:which_key_local_map['Q'] = [ 'qa'                                   , 'quit all' ]
let g:which_key_local_map['d'] = [ ':bd'                                  , 'delete buffer']

" Single mappings
let g:which_key_map['\'] = [ ':TagbarToggle'                      , 'Toggle tagbar' ]
let g:which_key_map['/'] = [ ':call Comment()'                    , 'comment' ]
let g:which_key_map[';'] = [ ':Commands'                          , 'commands' ]
let g:which_key_map['='] = [ '<C-W>='                             , 'balance windows' ]
let g:which_key_map['C'] = [ ':Codi!!'                            , 'virtual repl']
let g:which_key_map['e'] = [ ':CocCommand explorer'               , 'explorer' ]
let g:which_key_map['p'] = [ ':Files'                             , 'search files' ]
let g:which_key_map['P'] = [ ':!opout <c-r>%<CR><CR>'             , 'Preview file' ]
let g:which_key_map['f'] = [ ':Rg'                                , 'search text' ]
let g:which_key_map['_'] = [ '<C-W>s'                             , 'split below']
let g:which_key_map['|'] = [ '<C-W>v'                             , 'split right']
let g:which_key_map['c'] = [ ':w! | !compiler "<c-r>%"<CR>'      , 'Compile' ]
let g:which_key_map['X'] = [ ':split | term'                      , 'Terminal' ]
let g:which_key_map['L'] = [ ':Limelight!!'                       , 'Limelight toggle' ]
let g:which_key_map['z'] = [ 'Goyo'                               , 'zen' ]
let g:which_key_map['.'] = [ ':tabnew $MYVIMRC'                   , 'open init' ]
let g:which_key_map['R'] = [ ':source $MYVIMRC'                   , 'Reload vimrc' ]
let g:which_key_map['U'] = [ ':UndotreeToggle'                    , 'Undo Tree' ]
let g:which_key_map[' '] = 'No Highlight'

" Group mappings


" a is for actions
let g:which_key_map.a = {
            \ 'name' : '+actions' ,
            \ 'L' : [':Limelight'                                 , 'Limelight activate'],
            \ 'e' : [':CocCommand explorer'                       , 'explorer'],
            \ }

" b is for buffer
let g:which_key_map.b = {
            \ 'name' : '+buffer' ,
            \ '1' : ['b1'                                         , 'buffer 1'],
            \ '2' : ['b2'                                         , 'buffer 2'],
            \ 'd' : ['bd'                                         , 'delete-buffer'],
            \ 'f' : ['bfirst'                                     , 'first-buffer'],
            \ 'l' : ['blast'                                      , 'last-buffer'],
            \ 'n' : ['bnext'                                      , 'next-buffer'],
            \ 'p' : ['bprevious'                                  , 'previous-buffer'],
            \ '?' : ['Buffers'                                    , 'fzf-buffer'],
            \ '%' : ['%bd'                                        , 'kill all']
            \ }

" s is for search
let g:which_key_map.s = {
            \ 'name' : '+search' ,
            \ '/' : [':History/'                                  , 'history'],
            \ ';' : [':Commands'                                  , 'commands'],
            \ 'a' : [':Ag'                                        , 'text Ag'],
            \ 'b' : [':BLines'                                    , 'current buffer'],
            \ 'B' : [':Buffers'                                   , 'open buffers'],
            \ 'c' : [':Commits'                                   , 'commits'],
            \ 'C' : [':BCommits'                                  , 'buffer commits'],
            \ 'f' : [':Files'                                     , 'files'],
            \ 'g' : [':GFiles'                                    , 'git files'],
            \ 'G' : [':GFiles?'                                   , 'modified git files'],
            \ 'h' : [':History'                                   , 'file history'],
            \ 'H' : [':History:'                                  , 'command history'],
            \ 'l' : [':Lines'                                     , 'lines'] ,
            \ 'm' : [':Marks'                                     , 'marks'] ,
            \ 'M' : [':Maps'                                      , 'normal maps'] ,
            \ 'p' : [':Helptags'                                  , 'help tags'] ,
            \ 'P' : [':Tags'                                      , 'project tags'],
            \ 's' : [':CocList snippets'                          , 'snippets'],
            \ 'S' : [':Colors'                                    , 'color schemes'],
            \ 't' : [':Rg'                                        , 'text Rg'],
            \ 'T' : [':BTags'                                     , 'buffer tags'],
            \ 'w' : [':Windows'                                   , 'search windows'],
            \ 'y' : [':Filetypes'                                 , 'file types'],
            \ 'z' : [':FZF'                                       , 'FZF'],
            \ }
" \ 's' : [':Snippets'     , 'snippets'],

" g is for git
let g:which_key_map.g = {
            \ 'name' : '+git' ,
            \ 'a' : [':Git add .'                                 , 'add all'],
            \ 'A' : [':Git add %'                                 , 'add current'],
            \ 'b' : [':Git blame'                                 , 'blame'],
            \ 'B' : [':GBrowse'                                   , 'browse'],
            \ 'c' : [':Git commit'                                , 'commit'],
            \ 'd' : [':Git diff'                                  , 'diff'],
            \ 'D' : [':Gdiffsplit'                                , 'diff split'],
            \ 'g' : [':GGrep'                                     , 'git grep'],
            \ 's' : [':Gstatus'                                   , 'status'],
            \ 'h' : [':GitGutterLineHighlightsToggle'             , 'highlight hunks'],
            \ 'H' : ['<Plug>(GitGutterPreviewHunk)'               , 'preview hunk'],
            \ 'j' : ['<Plug>(GitGutterNextHunk)'                  , 'next hunk'],
            \ 'k' : ['<Plug>(GitGutterPrevHunk)'                  , 'prev hunk'],
            \ 'l' : [':Git log'                                   , 'log'],
            \ 'p' : [':Git push'                                  , 'push'],
            \ 'P' : [':Git pull'                                  , 'pull'],
            \ 'r' : [':GRemove'                                   , 'remove'],
            \ 'G' : ['<Plug>(GitGutterStageHunk)'                 , 'stage hunk'],
            \ 't' : [':GitGutterSignsToggle'                      , 'toggle signs'],
            \ 'u' : ['<Plug>(GitGutterUndoHunk)'                  , 'undo hunk'],
            \ 'v' : [':GV'                                        , 'view commits'],
            \ 'V' : [':GV!'                                       , 'view buffer commits'],
            \ }

" l is for language server protocol
let g:which_key_map.l = {
            \ 'name' : '+lsp' ,
            \ '.' : [':CocConfig'                                  , 'config'],
            \ ';' : ['<Plug>(coc-refactor)'                        , 'refactor'],
            \ 'a' : ['<Plug>(coc-codeaction)'                      , 'line action'],
            \ 'A' : ['<Plug>(coc-codeaction-selected)'             , 'selected action'],
            \ 'b' : [':CocNext'                                    , 'next action'],
            \ 'B' : [':CocPrev'                                    , 'prev action'],
            \ 'c' : [':CocList commands'                           , 'commands'],
            \ 'd' : ['<Plug>(coc-definition)'                      , 'definition'],
            \ 'D' : ['<Plug>(coc-declaration)'                     , 'declaration'],
            \ 'e' : [':CocList extensions'                         , 'extensions'],
            \ 'f' : ['<Plug>(coc-format-selected)'                 , 'format selected'],
            \ 'F' : ['<Plug>(coc-format)'                          , 'format'],
            \ 'h' : ['<Plug>(coc-float-hide)'                      , 'hide'],
            \ 'i' : ['<Plug>(coc-implementation)'                  , 'implementation'],
            \ 'I' : [':CocList diagnostics'                        , 'diagnostics'],
            \ 'j' : ['<Plug>(coc-float-jump)'                      , 'float jump'],
            \ 'l' : ['<Plug>(coc-codelens-action)'                 , 'code lens'],
            \ 'n' : ['<Plug>(coc-diagnostic-next)'                 , 'next diagnostic'],
            \ 'N' : ['<Plug>(coc-diagnostic-next-error)'           , 'next error'],
            \ 'o' : ['<Plug>(coc-openlink)'                        , 'open link'],
            \ 'O' : [':CocList outline'                            , 'outline'],
            \ 'p' : ['<Plug>(coc-diagnostic-prev)'                 , 'prev diagnostic'],
            \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'           , 'prev error'],
            \ 'q' : ['<Plug>(coc-fix-current)'                     , 'quickfix'],
            \ 'r' : ['<Plug>(coc-rename)'                          , 'rename'],
            \ 'R' : ['<Plug>(coc-references)'                      , 'references'],
            \ 's' : [':CocList -I symbols'                         , 'references'],
            \ 'S' : [':CocList snippets'                           , 'snippets'],
            \ 't' : ['<Plug>(coc-type-definition)'                 , 'type definition'],
            \ 'u' : [':CocListResume'                              , 'resume list'],
            \ 'U' : [':CocUpdate'                                  , 'update CoC'],
            \ 'z' : [':CocDisable'                                 , 'disable CoC'],
            \ 'Z' : [':CocEnable'                                  , 'enable CoC'],
            \ }

" t is for Toggling
let g:which_key_map.t = {
            \ 'name' : '+Toggle' ,
            \ 'n' : [':set nonumber!'                              , 'line-numbers'],
            \ 'r' : [':set norelativenumber!'                      , 'relative line nums'],
            \ 'w' : [':set wrap!'                                  , 'Word wrap'],
            \ 'c' : [':ColorizerToggle'                            , 'Colorizer'],
            \ 'l' : [':Limelight!!'                                , 'Limelight toggle' ],
            \ 'i' : [':IndentLinesToggle'                          , 'Indent lines'],
            \ 'u' : [':UndotreeToggle'                             , 'Undo Tree' ],
            \ 'h' : [':call ToggleHiddenAll()'                     , 'Hide' ]
            \ }

" m is for Saved Macros
let g:which_key_map.m = {
            \ 'name' : '+Macros' ,
            \ '{' : [':%s/\%V{/{{/g | %s/\%V}/}}/g'                , 'Replace braces with double braces for multiline formatted string'],
            \ 'j' : [":'<,'>!jq ."                                 , 'Format selection as json'],
            \ 'n' : [':%s/\\n/\r/g'                                , 'Replace \n with newline charFormat sqlalchemy query from logs'],
            \ '"' : [":%s/'/\"/g"                                  , "Replace ' with \""],
            \ "\'" : [":%s/\"/'/g"                                 , "Replace \" with '"],
            \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
call which_key#register(',', "g:which_key_local_map")
