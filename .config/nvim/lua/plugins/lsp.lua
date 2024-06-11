return {
  -- Explore https://github.com/hinell/lsp-timeout.nvim
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "simrat39/rust-tools.nvim", ft = "rs" },
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
    -- Lightweight yet powerful formatter
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = { "<leader>l" },
    opts = require "plugins.configs.conform",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = require "plugins.configs.nvim-lint",
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = opts.autocmd_callback,
      })
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
