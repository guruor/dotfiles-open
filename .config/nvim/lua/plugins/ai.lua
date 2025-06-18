local utils = require "utils"

return {
  {
    "ravitemer/mcphub.nvim",
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup()
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
      "CodeCompanionHistory",
    },
    -- Default config: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    opts = {
      default_adapter = "openrouter",
      display = {
        chat = {
          auto_scroll = false,
        },
      },
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true, -- Show mcp tool results in chat
          make_vars = true, -- Convert resources to #variables
          make_slash_commands = true, -- Add prompts as /slash commands
        },
      },
      history = {
        enabled = true,
        opts = {
          keymap = "gh",
          save_chat_keymap = "sc",
          auto_save = true,
        },
      },
    },
    keys = { "<leader>a" },
  },
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = require("plugins.configs.misc").chatgpt,
    config = function(_, opts)
      require("chatgpt").setup(opts)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    dependencies = { "zbirenbaum/copilot-cmp" },
    config = utils.load_config "configs.copilot",
    event = "InsertEnter",
    cmd = "Copilot",
    -- enabled = false,
  },
}
