return {
  defaults = { lazy = true },
  install = { colorscheme = { "gruvbox_material" } },

  ui = {
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = vim.g.border_style,
    icons = {
      ft = "",
      lazy = "鈴 ",
      loaded = "",
      not_loaded = "",
    },
  },

  checker = {
    -- automatically check for plugin updates
    enabled = true,
    concurrency = nil, ---@type number? set to 1 to check for updates very slowly
    notify = false, -- get a notification when new updates are found
    frequency = 86400, -- check for updates every day
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "matchparen",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
