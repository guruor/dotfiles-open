local M = {}
local home_dir = os.getenv "HOME"

M.session = function()
  local session_directory = home_dir .. "/.cache/nvim/session/"
  vim.g.session_directory = session_directory
  vim.g.prosession_dir = session_directory
  vim.g.prosession_last_session_dir = session_directory
end

M.gruvbox = function()
  vim.g.gruvbox_contrast_light = "medium"
  vim.g.gruvbox_contrast_dark = "medium"
  vim.g.gruvbox_invert_selection = 0
  vim.g.gruvbox_italic = 1
  vim.g.gruvbox_sign_column = "bg0"
end

M.gruvbox_material = function()
  vim.g.gruvbox_material_foreground = "material" -- Available values:   `'material'`, `'mix'`, `'original'`
  vim.g.gruvbox_material_background = "medium" -- Available values: 'hard', 'medium'(default), 'soft'
  vim.g.gruvbox_material_better_performance = 1
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_disable_italic_comment = 1
  vim.g.gruvbox_material_transparent_background = 0
end

M.tagbar = function()
  vim.g.tagbar_width = 30
  vim.g.tagbar_iconchars = { "↠", "↡" }
end

M.floaterm = function()
  vim.g.floaterm_width = 0.6
  vim.g.floaterm_height = 0.6
end

M.lf = function()
  vim.g.lf_map_keys = 0
  vim.g.lf_width = 0.75
  vim.g.lf_height = 0.75
  vim.g.NERDTreeHijackNetrw = 0 -- Add this line if you use NERDTree
  vim.g.lf_replace_netrw = 1 -- Open lf when vim opens a directory
end

M.whitespace = function()
  vim.g.better_whitespace_enabled = 1
  vim.g.strip_whitespace_on_save = 1
  vim.g.strip_only_modified_lines = 1
  vim.g.strip_whitespace_confirm = 0
  -- vim.g.better_whitespace_ctermcolor='grey'
  vim.g.better_whitespace_guicolor = "#3c3836"
end

M.comment = function()
  require("Comment").setup {
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  }
end

M.neoterm = function()
  vim.g.neoterm_default_mod = "botright"
  vim.g.neoterm_size = 12
  vim.g.neoterm_autoinsert = 1
  vim.g.neoterm_shell = "/bin/zsh"
end

M.smartcolumn = {
  colorcolumn = "120",
  disabled_filetypes = { "help", "text", "markdown" },
  custom_colorcolumn = {},
  scope = "file",
}

M.blankline = {
  enabled = true,
  char = "┊",
  context_char = "│",
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "make",
    "",
  },
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = false,
  show_end_of_line = true,
  space_char_blankline = " ",
  use_treesitter = true,
  strict_tabs = true,
}

M.chatgpt = {
  chat = {
    welcome_message = "",
    question_sign = "", -- 🙂
    answer_sign = "ﮧ", -- 🤖
    chat_layout = {
      size = {
        height = "85%",
        width = "85%",
      },
    },
    chat_window = {
      win_options = {
        winblend = 0,
        winhighlight = "Normal:ChatGPTWindow,FloatBorder:FloatBorder",
      },
    },
    chat_input = {
      prompt = "   ",
      win_options = {
        winblend = 0,
        winhighlight = "Normal:ChatGPTPrompt,ChatGPTPrompt:FloatBorder",
      },
    },
    keymaps = {
      close = { "<Esc>", "<C-c>" },
      yank_last = "<C-y>",
      scroll_up = "<C-u>",
      scroll_down = "<C-d>",
      toggle_settings = "<C-o>",
      new_session = "<C-n>",
      cycle_windows = "<Tab>",
    },
  },
  popup_input = {
    submit = "<C-s>",
  },
}

M.surround = {
  keymaps = {
    insert = "g<C-g>s",
    insert_line = "g<C-g>S",
    normal = "gys",
    normal_cur = "gyss",
    normal_line = "gyS",
    normal_cur_line = "gySS",
    visual = "gS",
    visual_line = "ggS",
    delete = "gds",
    change = "gcs",
  },
}

return M
