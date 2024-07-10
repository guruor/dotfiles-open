local utils = require "utils"

return {
  { -- Editor look and feel
    "nvim-tree/nvim-web-devicons",
  },
  { "MunifTanjim/nui.nvim" },
  {
    -- Better `vim.notify()`
    "rcarriga/nvim-notify",
    event = "VeryLazy",
  },
  {
    "nvimdev/dashboard-nvim",
    config = utils.load_config "configs.dashboard",
    -- Only load when no arguments
    event = function()
      if vim.fn.argc() == 0 then
        return "VimEnter"
      end
    end,
    cmd = "Dashboard",
  },
  {
    -- For improved vim.ui interfaces
    "stevearc/dressing.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = require("plugins.configs.misc").dressing,
  },
  {
    "akinsho/bufferline.nvim",
    -- version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = require("plugins.configs.bufferline"),
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    event = "VeryLazy",
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = require("plugins.configs.statusline"),
    -- event = { 'BufReadPre', 'BufNewFile' },
    lazy = false,
    priority = 999,
    config = function(_, opts)
      require("lualine").setup(opts)
    end
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = require("plugins.configs.misc").noice,
    config = function(_, opts)
      require("noice").setup(opts)
    end,
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = require("plugins.configs.misc").blankline,
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
    event = { "BufReadPost" },
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "VeryLazy",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    -- Merges vim statusline with tmux
    "vimpostor/vim-tpipeline",
    -- event = { 'BufReadPre', 'BufNewFile' }, -- Can't lazy load, if lazy loaded duplicate statusline appears
    lazy = false,
    priority = 998,
  },
  {
    "m4xshen/smartcolumn.nvim",
    event = "VeryLazy",
    opts = require("plugins.configs.misc").smartcolumn,
    config = function(_, opts)
      require("smartcolumn").setup(opts)
    end,
  },
  {
    -- For better preview of quickfix buffers
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },
  {
    -- Improve folding
    "kevinhwang91/nvim-ufo",
    -- event = "VeryLazy",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "kevinhwang91/promise-async",
    },
    init = function()
      require("plugins.configs.ufo").SetVimOptions()
    end,
    opts = require("plugins.configs.ufo").options,
    config = function(_, opts)
      require("ufo").setup(opts)
    end,
    enabled = false,
  },
  {
    "karb94/neoscroll.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "beauwilliams/focus.nvim",
    event = "VeryLazy",
    config = 'require("focus").setup()',
  },
}
