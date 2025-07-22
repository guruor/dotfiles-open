return {
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
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        env = {
          -- api_key = "cmd:bw get password OAI_API_KEY",
          api_key = "cmd:bw get password AI_API_KEY",
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
}
