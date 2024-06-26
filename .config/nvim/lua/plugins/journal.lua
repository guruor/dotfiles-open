local utils = require "utils"

return {
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "vimwiki", "norg" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function(_, opts)
      require("plugins.configs.headlines").SetHighlights()
      -- Loading it here, as it requires the treesitter queries to be available
      opts = require("plugins.configs.headlines").options
      require("headlines").setup(opts)
    end,
  },
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/zen-mode.nvim",
      "max397574/neorg-contexts",
    },
    -- build = ":Neorg sync-parsers",
    cmd = { "Neorg" },
    ft = { "norg" },
    opts = require("plugins.configs.neorg").options,
    config = function(_, opts)
      require("neorg").setup(opts)
    end,
  },
  -- VimWiki for note management
  {
    "vimwiki/vimwiki",
    ft = { "markdown", "vimwiki" },
    keys = { { "<leader>w", mode = { "n", "v" } } },
    -- lazy = false,
    dependencies = {
      { "mattn/calendar-vim", cmd = { "CalendarH", "CalendarH" } },
      { "AckslD/nvim-FeMaco.lua", cmd = "FeMaco", config = 'require("femaco").setup()' }, -- For inline code-block edit
      {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown", "vimwiki" },
        -- lazy = false,
        build = 'function() vim.fn["mkdp#util#install"]() end',
      },
      -- {
      --   -- vim-polyglot is needed for `plantuml` syntax
      --   "sheerun/vim-polyglot",
      --   event = "VeryLazy",
      -- },
    },
    init = function()
      require "plugins.configs.vimwiki"
    end,
    config = function()
      local currPath = vim.fn.getcwd() .. "/"
      InitializeVimwikiVars(currPath)
    end,
    enabled = false,
  },
  {
    "ron89/thesaurus_query.vim",
    keys = { { "<leader>a" } },
    config = utils.load_config "configs.thesaurus",
  },
  -- Better working environment
  { "folke/twilight.nvim", cmd = "Twilight", config = 'require("twilight").setup()' },
  { "folke/zen-mode.nvim", cmd = "ZenMode", config = 'require("zen-mode").setup()' },
  {
    -- https://github.com/3rd/image.nvim/issues/91, works only with luarocks 5.1
    "3rd/image.nvim",
    ft = { "markdown", "vimwiki", "norg" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = require("plugins.configs.image").options,
    config = function(_, opts)
      require("image").setup(opts)
    end,
    enabled = false,
  },
}
