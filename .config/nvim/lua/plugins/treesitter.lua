return {
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo", "TSUpdateSync", "TSUpdate" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    build = ":TSUpdate",
    dependencies = {
      { "LiadOz/nvim-dap-repl-highlights" },
    },
    config = function()
      -- dap-repl must be initialized before treesiter initialisation
      require("nvim-dap-repl-highlights").setup()
      local ts = require "plugins.configs.treesitter"
      require("nvim-treesitter.configs").setup(ts.options)
      ts.additional_setup()
    end,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require "nvim-treesitter.textobjects.move" ---@type table<string,fun(...)>
      local configs = require "nvim-treesitter.configs"
      for name, fn in pairs(move) do
        if name:find "goto" == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find "[%]%[][cC]" then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "css",
      "lua",
      "xml",
      "php",
      "markdown",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
