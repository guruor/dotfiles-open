local M = {}

M.gruvbox_material = function()
  vim.g.gruvbox_material_foreground = "material" -- Available values:   `'material'`, `'mix'`, `'original'`
  vim.g.gruvbox_material_background = "medium" -- Available values: 'hard', 'medium'(default), 'soft'
  vim.g.gruvbox_material_better_performance = 1
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_disable_italic_comment = 0
  vim.g.gruvbox_material_transparent_background = 0
end

M.tagbar = function()
  vim.g.tagbar_width = 30
  vim.g.tagbar_iconchars = { "↠", "↡" }
end

M.tfm = {
  -- Possible choices: "ranger" | "nnn" | "lf" | "vifm" | "yazi" (default)
  file_manager = "yazi",
  replace_netrw = true,
  ui = {
    border = vim.g.border_style,
    height = 0.95,
    width = 0.95,
    x = 0.5,
    y = 0.5,
  },
}

M.smartcolumn = {
  colorcolumn = "120",
  disabled_filetypes = { "help", "text", "markdown", "norg", "dashboard", "csv" },
  -- Or define max_line_length in .editorconfig
  custom_colorcolumn = { python = "100" },
  scope = "file",
}

M.blankline = {
  enabled = true,
  scope = { enabled = false },
  exclude = {
    filetypes = {
      "help",
      "terminal",
      "lazy",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "mason",
      "make",
      "markdown",
      "vimwiki",
      "norg",
      "",
    },
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

M.nvimGo = {
  notify = true,
  auto_format = false,
  auto_lint = false,
  linter = 'golangci-lint',
}

M.noice = {
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = true,
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

M.diffview = {
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    },
  },
}

M.treesitter_context = {
  mode = "cursor",
  max_lines = 3,
}

M.gitlinker = {
  router = {
    -- https://git.realestate.com.au/
    browse = {
      ["^git%.realestate%.com%.au"] = "https://git.realestate.com.au/"
       .. "{_A.ORG}/"
       .. "{_A.REPO}/blob/"
       .. "{_A.REV}/"
       .. "{_A.FILE}?plain=1" -- '?plain=1'
       .. "#L{_A.LSTART}"
       .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
    },
  }
}

M.neogit = {
  -- Hides the hints at the top of the status buffer
  disable_hint = false,
  -- Disables signs for sections/items/hunks
  disable_signs = true,
  -- signs = {
  --   -- { CLOSED, OPENED }
  --   hunk = { "", "" },
  --   item = { "▸", "▾" },
  --   section = { ">", "v" },
  -- }
}

M.ts_context_commentstring = {
  enable_autocmd = false,
  languages = {
    javascript = {
      __default = "// %s",
      jsx_element = "{/* %s */}",
      jsx_fragment = "{/* %s */}",
      jsx_attribute = "// %s",
      comment = "// %s",
    },
    typescript = { __default = "// %s", __multiline = "/* %s */" },
    http = { __default = "# %s", __multiline = "<!-- %s -->" },
  },
}

M.venv_selector = {
  options = {
    picker = "auto", -- The picker to use. Valid options are "telescope", "fzf-lua", "native", or "auto"
    debug = true,
    notify_user_on_venv_activation = true,
  },
  search = {
    find_venvs = { command = "fd /bin/python$ $PYTHON_VENV_PATH --full-path" },
    find_poetry_venvs = { command = "fd /bin/python$ $POETRY_CACHE_DIR --full-path" },
    find_pyenv_venvs = { command = "fd /bin/python$ $PYENV_ROOT --full-path" },
  },
}

return M
