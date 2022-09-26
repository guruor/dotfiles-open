" Refer this source for other syntax properties to override
" https://github.com/tpope/vim-markdown/blob/master/syntax/markdown.vim
" Unicode symbols ['•', '◦', '▸', '▹', '▪', '▫']

" syntax match unorderedListItemIndent1 /^[-,\*] / containedin=ALL
" syntax match unorderedBulletIndent1 /[-,\*]/ containedin=unorderedListItemIndent1 contained conceal cchar=•

" syntax match unorderedListItemIndent2 /^[ ]\{4}[-,\*] / containedin=ALL
" syntax match unorderedBulletIndent2 /[-,\*]/ containedin=unorderedListItemIndent2 contained conceal cchar=◦

" syntax match unorderedListItemIndent3 /^[ ]\{8}[-,\*] / containedin=ALL
" syntax match unorderedBulletIndent3 /[-,\*]/ containedin=unorderedListItemIndent3 contained conceal cchar=▫

" highlight htmlH1 guifg=#50fa7b gui=bold
" highlight htmlH2 guifg=#8be9fd gui=bold
" highlight htmlH3 guifg=#ff79c6 gui=bold
" highlight htmlH4 guifg=#ffb86c gui=bold
" highlight htmlH5 guifg=#f1fa8c gui=bold

" highlight markdownCode ctermfg=Cyan guifg=#80a0ff
" highlight markdownCodeBlock ctermfg=Cyan guifg=#80a0ff
