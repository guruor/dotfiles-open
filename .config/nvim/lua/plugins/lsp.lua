return {
  -- Explore https://github.com/hinell/lsp-timeout.nvim
  {
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "VeryLazy",
    init = function()
      vim.g.lspTimeoutConfig = {
        stopTimeout = 1000 * 60 * 5, -- ms, timeout before stopping all LSPs
        startTimeout = 1000 * 10, -- ms, timeout before restart
        silent = false, -- true to suppress notifications
        filetypes = {
          ignore = { -- filetypes to ignore; empty by default
            -- lsp-timeout is disabled completely
          }, -- for these filetypes
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        build = ":MasonUpdate",
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvimtools/none-ls-extras.nvim" },
        enabled = false,
      },
      "b0o/schemastore.nvim",
      -- { dir = "~/Workspace/vim-plugins/none-ls.nvim" },
    },
    config = function()
      require "lsp"
    end,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig", "mfussenegger/nvim-dap-python" },
    opts = require("plugins.configs.misc").venv_selector,
    config = function(_, opts)
      require("venv-selector").setup(opts)
    end,
    lazy = false,
    enabled = true,
  },
  {
    -- Lightweight yet powerful formatter
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim", "zapling/mason-conform.nvim" },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = { "<leader>l" },
    opts = require "plugins.configs.conform",
    config = function(_, opts)
      require("conform").setup(opts)
      require("mason-conform").setup {
        ignore_install = {},
      }
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    dependencies = { "rshkarin/mason-nvim-lint" },
    event = { "BufReadPre", "BufNewFile" },
    opts = require "plugins.configs.nvim-lint",
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = opts.autocmd_callback,
      })

      require("mason-nvim-lint").setup {
        ignore_install = { "biomejs" },
      }
    end,
  },
  {
    -- Alternative: https://github.com/olexsmir/gopher.nvim
    "crispgm/nvim-go",
    ft = { "go", "gomod" },
    opts = require("plugins.configs.misc").nvimGo,
    config = function(_, opts)
      require("go").setup(opts)
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    lazy = false,
  },
  -- Managing and installing LSP servers
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- `vim.uv` typings
  {
    -- Proto buf lint and format
    "bufbuild/vim-buf",
  },
}
