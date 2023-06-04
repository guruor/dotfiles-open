local M = {}

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

M.lf = function()
  vim.g.lf_netrw = 1

  require("lf").setup {
    winblend = 5,
    escape_quit = true,
    default_action = "tabedit", -- default action when `Lf` opens a file
    border = vim.g.border_style,
    height = 0.75, -- height of the *floating* window
    width = 0.75, -- width of the *floating* window
    direction = "float", -- window type: float horizontal vertical
    highlights = {
      Normal = { guibg = nil },
      NormalFloat = { guibg = nil },
      FloatBorder = { guibg = nil, guifg = nil },
    },
  }
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
      close = { "<C-c>" },
      yank_last = "<C-y>",
      yank_last_code = "<C-k>",
      scroll_up = "<C-u>",
      scroll_down = "<C-d>",
      new_session = "<C-n>",
      cycle_windows = "<Tab>",
      cycle_modes = "<C-f>",
      select_session = "<Space>",
      rename_session = "r",
      delete_session = "d",
      draft_message = "<C-d>",
      toggle_settings = "<C-o>",
      toggle_message_role = "<C-r>",
      toggle_system_role_open = "<C-s>",
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

M.auto_session = {
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Workspace", "~/Downloads", "/" },
  pre_save_cmds = {
    RemoveFugitiveTab,
    CloseAllFloatingWindows,
  },
  session_lens = {
    load_on_setup = false,
  },
}

M.dressing = {
  select = {
    backend = { "fzf_lua", "telescope", "fzf", "builtin", "nui" },
    fzf_lua = {
      winopts = {
        height = 0.5,
        width = 0.5,
      },
    },
  },
}

M.noice = {
  presets = {
    long_message_to_split = true,
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- Read this to understand what kind messages needs to be filtered
  -- https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages
  routes = {
    {
      filter = { event = "msg_showmode" },
      view = "cmdline",
    },
    {
      -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#hide-written-messages
      filter = {
        any = {
          { event = "msg_show", kind = "", find = "[w]" },
          { event = "msg_show", kind = { "", "echo" }, find = "seconds? ago" },
          { event = "msg_show", kind = "emsg", find = "E486" },
          -- { event = "msg_show", kind = { "echo", "echomsg" }, instant = true },
          -- { event = "msg_show", find = "E325" },
          -- { event = "msg_show", find = "Found a swap file" },
        },
      },
      opts = { skip = true },
    },
  },
}

return M
