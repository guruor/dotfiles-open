local utils = require "utils"

return {
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    config = true,
  },
  {
    -- Extend and create a/i textobjects, also extends nvim-treesitter/nvim-treesitter-textobjects
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = "VeryLazy",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- TODO: register all text objects with which-key similar to LazyVim
    end,
  },
  {
    -- Fast and feature-rich surround actions. For text that includes
    -- surrounding characters like brackets or quotes, this allows you
    -- to select the text inside, change or modify the surrounding characters,
    -- and more.
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    config = utils.load_config "configs.cmp",
    dependencies = {
      -- cmp sources plugins
      {
        {
          "garymjr/nvim-snippets",
          opts = {
            friendly_snippets = true,
            extended_filetypes = {
              typescript = { "javascript", "tsdoc" },
              javascript = { "jsdoc" },
              html = { "css", "javascript" },
              lua = { "luadoc" },
              python = { "python-docstring" },
              sh = { "shelldoc" },
              php = { "phpdoc" },
              vimwiki = { "markdown" },
            },
          },
          config = function(_, opts)
            require("snippets").setup(opts)
          end,
          dependencies = { "rafamadriz/friendly-snippets" },
          event = "InsertEnter",
        },
        "hrsh7th/cmp-nvim-lua",
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-calc" },
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "onsails/lspkind.nvim",
        {
          "rcarriga/cmp-dap",
          ft = { "dap-repl", "dapui_watches", "dapui_hover" },
        },
        { "f3fora/cmp-spell" },
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- easily search for, substitute, and abbreviate multiple variants of a word, replaces vim-abolish
  {
    "johmsalas/text-case.nvim",
    config = 'require("textcase").setup()',
    keys = { { "ga", mode = { "n", "v" } } },
  },
  {
    -- annotation generator/docstring
    "danymat/neogen",
    config = true,
    event = "VeryLazy",
  },
}
