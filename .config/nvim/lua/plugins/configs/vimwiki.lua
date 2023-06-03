-- Ensure files are read as what "Multiple Wikis
-- https://opensource.com/article/18/6/vimwiki-gitlab-notes
--
-- Use wiki names via :h vimwiki-option-name
-- Clone off a default https://github.com/vimwiki/vimwiki/issues/365

local defaultWiki = {
    auto_diary_index = 1,
    ext = "md",
    syntax = "markdown",
}

local mostUsedWiki = copy(defaultWiki)
mostUsedWiki.path = vim.fn.expand "$MOST_USED_VIMWIKI_DIR"
mostUsedWiki.name = "Most Used"

local activeTaskWiki = copy(defaultWiki)
activeTaskWiki.path = vim.fn.expand "$VIMWIKI_DIR_ACTIVE_TASKS"
activeTaskWiki.name = "Active Task"

local discussionWiki = copy(defaultWiki)
discussionWiki.path = vim.fn.expand "$VIMWIKI_DIR_DISCUSSIONS"
discussionWiki.name = "Discussions"

local workWiki = copy(defaultWiki)
workWiki.path = vim.fn.expand "$VIMWIKI_DIR_WORK"
workWiki.name = "Work"

local personalWiki = copy(defaultWiki)
personalWiki.path = vim.fn.expand "$VIMWIKI_DIR_PERSONAL"
personalWiki.name = "Personal"

local interviewWiki = copy(defaultWiki)
interviewWiki.path = vim.fn.expand "$VIMWIKI_DIR_INTERVIEWS"
interviewWiki.name = "Interview Taken"

vim.g.vimwiki_list = { mostUsedWiki, activeTaskWiki, discussionWiki, interviewWiki, workWiki, personalWiki }

-- In vimwiki list, You can add/toggle a checkbox using ctrl-<Space>, use gl<Space> to remove checkbox.
-- use `gln` to toggle forward completion levels, and use `glp` to toggle backwards completion levels. Levels progress through '.oOX'
vim.g.vimwiki_listsyms = "✗○◐●✓" -- Default value ' .oOX'
vim.g.vimwiki_ext2syntax = {
    [".Rmd"] = "markdown",
    [".markdown"] = "markdown",
    [".md"] = "markdown",
    [".mdown"] = "markdown",
    [".rmd"] = "markdown",
}

vim.g.vimwiki_hl_headers = 1

-- Markdown code block color syntax
vim.g.markdown_fenced_languages = {
    "bash=sh",
    "javascript",
    "js=javascript",
    "json=javascript",
    "typescript",
    "ts=typescript",
    "python",
    "html",
    "css",
    "rust",
    "go",
    "vim",
    "lua",
    -- "plantuml",
    "git",
}
