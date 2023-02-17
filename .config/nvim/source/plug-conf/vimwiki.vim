" Ensure files are read as what "Multiple Wikis
" https://opensource.com/article/18/6/vimwiki-gitlab-notes
"
" Use wiki names via :h vimwiki-option-name
" Clone off a default https://github.com/vimwiki/vimwiki/issues/365
    let defaultWiki = {'auto_diary_index': 1}
    let defaultWiki.syntax = 'markdown'
    let defaultWiki.ext = 'md'

    let mostUsedWiki = copy(defaultWiki)
    let mostUsedWiki.path = $MOST_USED_VIMWIKI_DIR
    let mostUsedWiki.name = 'Most Used'

    let activeTaskWiki = copy(defaultWiki)
    let activeTaskWiki.path = $VIMWIKI_DIR_ACTIVE_TASKS
    let activeTaskWiki.name = 'Active Task'

    let discussionWiki = copy(defaultWiki)
    let discussionWiki.path = $VIMWIKI_DIR_DISCUSSIONS
    let discussionWiki.name = 'Discussions'

    let workWiki = copy(defaultWiki)
    let workWiki.path = $VIMWIKI_DIR_WORK
    let workWiki.name = 'Work'

    let personalWiki = copy(defaultWiki)
    let personalWiki.path = $VIMWIKI_DIR_PERSONAL
    let personalWiki.name = 'Personal'

    let interviewWiki = copy(defaultWiki)
    let interviewWiki.path = $VIMWIKI_DIR_INTERVIEWS
    let interviewWiki.name = 'Interview Taken'

    let g:vimwiki_list = [mostUsedWiki, activeTaskWiki, discussionWiki, interviewWiki, workWiki, personalWiki]

    " In vimwiki list, You can add/toggle a checkbox using ctrl-<Space>, use gl<Space> to remove checkbox.
    " use `gln` to toggle forward completion levels, and use `glp` to toggle backwards completion levels. Levels progress through '.oOX'
    let g:vimwiki_listsyms = '✗○◐●✓' " Default value ' .oOX'
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
    let g:vimwiki_hl_headers=1


" Markdown code block color syntax
let g:markdown_fenced_languages = ['bash=sh', 'javascript', 'js=javascript', 'json=javascript', 'typescript', 'ts=typescript', 'python', 'html', 'css', 'rust', 'go', 'vim', 'lua', 'plantuml']
