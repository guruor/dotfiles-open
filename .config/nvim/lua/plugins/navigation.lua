local utils = require "utils"

return {
  { "christoomey/vim-tmux-navigator", event = "VeryLazy" }, -- Switch windows with C-[h,j,k,l,\], same for tmux panes
  {
    -- File navigator, uses terminal file manager (yazi, lf, ranger) to navigate and change working directory
    "rolv-apneseth/tfm.nvim",
    opts = require("plugins.configs.misc").tfm,
    config = function(_, opts)
      require("tfm").setup(opts)
    end,
  },
  {
    -- Easy search, navigation
    "ibhagwan/fzf-lua",
    dependencies = {
      { "junegunn/fzf", build = "./install --bin" },
    },
    cmd = { "FzfLua", "FzfGrepProjectWithSelection", "FzfBlinesWithSelection", "FzfSearchInSpecificDirectory" },
    config = utils.load_config "configs.fzf",
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-zoxide",
    },
    config = utils.load_config "configs.telescope",
    enabled = true,
  },
  {
    "folke/flash.nvim", -- leap.nvim alternative
    event = "VeryLazy",
    config = true,
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    -- Only load whichkey after all the gui
    "folke/which-key.nvim",
    keys = { "<leader>", "<localleader>", ",", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g",
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    cmd = "WhichKey",
    config = function()
      require("plugins.configs.whichkey").load()
    end
  },
  {
    -- Vim subword movement with w, e, b
    "chrisgrieser/nvim-spider",
    config = utils.load_config "configs.spider",
    keys = { "w", "e", "b" }
  },
  {
    -- Doesn't work with lazy loading
    "andymass/vim-matchup",
    -- keys = { { "%", mode = { "n", "v" } }, { "g%", mode = { "n", "v" } } },
    event = { "BufReadPost" },
    init = function()
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_matchparen_deferred = 1
    end,
    config = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    -- Go forward/backward with square brackets
    "echasnovski/mini.bracketed",
    version = false,
    event = "VeryLazy",
    opts = {
      file = { suffix = "" },
      yank = { suffix = "" },
    },
    config = function(_, opts)
      require("mini.bracketed").setup(opts)
    end,
  },
  {
    -- IDE-like breadcrumbs
    "Bekaboo/dropbar.nvim",
    event = "BufRead",
    -- Lazy loading is already handled by plugin
    -- https://github.com/Bekaboo/dropbar.nvim/blob/master/plugin/dropbar.lua
    lazy = false,
    config = function()
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
  },
  {
    -- For code outline window
    "stevearc/aerial.nvim",
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
    cmd = { "AerialToggle" },
  },
}
