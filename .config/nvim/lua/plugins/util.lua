return {
  {
    "LunarVim/bigfile.nvim",
    lazy = false,
  },
  {
    -- Task runner
    "stevearc/overseer.nvim",
    keys = { { "<leader>t" } },
    cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
    opts = require "plugins.configs.overseer",
    config = function(_, opts)
      require("overseer").setup(opts)
    end,
  },
  {
    "rmagatti/auto-session",
    opts = require("plugins.configs.misc").auto_session,
    init = function(_, opts)
      require("auto-session").setup(opts)
    end,
    lazy = false,
  },
  {
    "chrisgrieser/nvim-recorder",
    opts = {
      slots = { "a", "b" },

      mapping = {
        -- Mapping <Leader>r is used to run certain saved macro
        -- Mapping <Leader>s is used to run certain Substitute commands
        startStopRecording = "q",
        playMacro = "Q",
        editMacro = "<Leader>mi",
        yankMacro = "<Leader>my",
        deleteAllMacros = "<Leader>mD",
        switchSlot = "<Leader>mT",
      },
    },
    event = "VeryLazy",
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    keys = {
      { "<c-q>", [[:ToggleTerm<cr>]], silent = true },
      { "<c-q>", [[<c-\><c-n>:ToggleTerm<cr>]], mode = "t", silent = true },
    },
  },
  {
    -- Color picker and highlighter plugin for Neovim.
    "uga-rosa/ccc.nvim",
    cmd = { "CccHighlighterToggle", "CccConvert", "CccPick" },
    opts = {
      highlighter = { auto_enable = true, lsp = true },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    cmd = { "Hardtime" },
    opts = { max_count = 5, disable_mouse = false },
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "https://gitlab.com/itaranto/plantuml.nvim",
    version = "*",
    config = function()
      require("plantuml").setup()
    end,
    cmd = "PlantUML",
  },
  {
    "mistricky/codesnap.nvim",
    build = "make",
    cmd = { "CodeSnap", "CodeSnapSave" },
    opts = {
      save_path = "~/Pictures/Pictures",
      has_breadcrumbs = true,
      watermark = "",
    },
  },
}
