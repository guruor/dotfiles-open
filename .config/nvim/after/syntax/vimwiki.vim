" Refer this source for other syntax properties to override
" https://github.com/vimwiki/vimwiki/blob/master/syntax/vimwiki.vim
" Unicode symbols ['•', '◦', '▸', '▹', '▪', '▫']

syntax match unorderedListItemIndent1 /^[-,\*] / containedin=ALL
syntax match unorderedBulletIndent1 /[-,\*]/ containedin=unorderedListItemIndent1 contained conceal cchar=•

syntax match unorderedListItemIndent2 /^[ ]\{4}[-,\*] / containedin=ALL
syntax match unorderedBulletIndent2 /[-,\*]/ containedin=unorderedListItemIndent2 contained conceal cchar=◦

syntax match unorderedListItemIndent3 /^[ ]\{8}[-,\*] / containedin=ALL
syntax match unorderedBulletIndent3 /[-,\*]/ containedin=unorderedListItemIndent3 contained conceal cchar=▫

syn match Statement "^> .*"

" highlight VimwikiHeader1 guifg=#50fa7b gui=bold
" highlight VimwikiHeader2 guifg=#8be9fd gui=bold
" highlight VimwikiHeader3 guifg=#ff79c6 gui=bold
" highlight VimwikiHeader4 guifg=#ffb86c gui=bold
" highlight VimwikiHeader5 guifg=#f1fa8c gui=bold

" highlight VimwikiCode ctermfg=Cyan guifg=#80a0ff
" highlight VimwikiPre ctermfg=Cyan guifg=#80a0ff
