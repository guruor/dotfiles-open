local utils = require "utils"

return {
  {
    "robitx/gp.nvim",
    dir = utils.local_plugins_dir() .. "/gp.nvim",
    dev = vim.fn.isdirectory(utils.local_plugins_dir() .. "/gp.nvim") == 1,
    config = function()
      local conf = require "plugins.configs.gp"
      require("gp").setup(conf)
    end,
    cmd = { "GpWhisper", "GpNextAgent" },
  },
  {
    "ravitemer/mcphub.nvim",
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup()
    end,
  },
  {
    -- Install the `vectorcode` first: uv tool install vectorcode
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "uv tool upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    cmd = { "VectorCode" },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
      "ravitemer/mcphub.nvim",
      "Davidyz/VectorCode",
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
      default_adapter = "copilot",
      strategies = {
        chat = {
          opts = {
            completion_provider = "blink", -- blink|cmp|coc|default
          },
        },
      },
      display = {
        chat = {
          auto_scroll = false,
        },
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                -- default = "gpt-4.1",
                default = "claude-3.7-sonnet",
              },
            },
          })
        end,
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
        vectorcode = {
          opts = {
            add_tool = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("plugins.configs.companion-notification").init()
      require("codecompanion").setup(opts)
    end,
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
    config = utils.load_config "configs.copilot",
    event = "InsertEnter",
    cmd = "Copilot",
    -- enabled = false,
  },
}
