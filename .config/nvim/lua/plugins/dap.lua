return {
  {
    -- Debugging
    "mfussenegger/nvim-dap",
    keys = { "<leader>d" },
    cmd = { "DapUIToggle", "DapToggleRepl", "DapToggleBreakpoint" },
    config = function()
      require "dbg"
    end,
    dependencies = {
      "Weissle/persistent-breakpoints.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
    },
  },
  {
    -- Enable virutal text, requires theHamsta/nvim-dap-virtual-text
    "theHamsta/nvim-dap-virtual-text",
    init = function()
      vim.g.dap_virtual_text = true
    end,
    config = true,
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    config = function(_, opts)
      require("persistent-breakpoints").setup(opts)
    end,
  },
  {
    "andrewferrier/debugprint.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- Needed to enable treesitter for NeoVim 0.8
    },
    -- Remove the following line to use development versions,
    -- not just the formal releases
    version = "*",
    config = true,
    keys = { "g?" },
  },
}
