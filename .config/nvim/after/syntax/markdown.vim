" Refer this source for other syntax properties to override
" https://github.com/tpope/vim-markdown/blob/master/syntax/markdown.vim
" Unicode symbols ['•', '◦', '▸', '▹', '▪', '▫']

" syntax match unorderedListItemIndent1 /^[-,\*] / containedin=ALL
" syntax match unorderedBulletIndent1 /[-,\*]/ containedin=unorderedListItemIndent1 contained conceal cchar=•

" syntax match unorderedListItemIndent2 /^[ ]\{4}[-,\*] / containedin=ALL
" syntax match unorderedBulletIndent2 /[-,\*]/ containedin=unorderedListItemIndent2 contained conceal cchar=◦

" syntax match unorderedListItemIndent3 /^[ ]\{8}[-,\*] / containedin=ALL
" syntax match unorderedBulletIndent3 /[-,\*]/ containedin=unorderedListItemIndent3 contained conceal cchar=▫
