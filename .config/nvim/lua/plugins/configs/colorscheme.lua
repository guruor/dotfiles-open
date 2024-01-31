-- Colorscheme and Highlights
-- ----------------

-- Setting truecolor support
if vim.fn.has('termguicolors') then
    vim.opt.termguicolors = true
end

-- Setting background as per dark mode flag
local home_dir=os.getenv("HOME")
local dark_mode_flag_file=home_dir .. '/.cache/dark-mode.off'
local f=io.open(dark_mode_flag_file,"r")
if f~=nil then
  io.close(f)
  vim.cmd('set background=light')
else
  vim.cmd('set background=dark')
end

-- Setting colorscheme
-- vim.cmd('colorscheme ' .. vim.g.current_colorscheme)

-- Setting colorscheme overriding laststatus, so needed to redeclare
-- vim.opt.laststatus = 3


-- Highlights

-- Transparent Background (For i3 and compton)
-- vim.api.nvim_set_hl(0, 'Normal', { guibg = nil, ctermbg = nil })
-- vim.api.nvim_set_hl(0, 'LineNr', { guibg = nil, ctermbg = nil })

-- No highlight for window separator, userful with global statusline
-- highlight WinSeparator guibg=None
vim.api.nvim_set_hl(0, 'WinSeparator', { guibg = nil })
vim.api.nvim_set_hl(0, 'FloatBorder', { guibg = nil })
vim.api.nvim_set_hl(0, 'NormalFloat', { guibg = nil })

-- Gruvbox material by default underlines the unused variable, this will make the text grey like a comment
vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { link = 'Comment' })

-- Turns off highlighting on the bits of code that are changed, so the line that is
-- changed is highlighted but the actual text that has changed stands out on the line and is readable.
if vim.api.nvim_win_get_option(0, "diff") then
    vim.api.nvim_set_hl(0, 'link')
    vim.api.nvim_set_hl(0, 'DiffText')
    vim.api.nvim_set_hl(0, 'MatchParen')
end

-- " LspSaga remove border highlighting
-- " highlight SagaBorder guifg=#ffffff guibg=None
vim.api.nvim_set_hl(0, 'SagaBorder', { fg = "#ffffff", bg = nil })
