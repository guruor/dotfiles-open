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
    action_palette = {
      opts = {
        show_default_actions = true,
        show_default_prompt_library = false,
      },
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
  prompt_library = {
    ["Commit Message with Jira ID"] = {
      strategy = "chat",
      description = "Generate a commit message with Jira ID",
      opts = {
        index = 9,
        is_default = false,
        is_slash_cmd = true,
        short_name = "commit_with_jira_id",
        auto_submit = true,
      },
      prompts = {
        {
          role = "system",
          content = "You are an experienced developer with expertise in Git best practices and writing meaningful commit messages. You follow conventional commit standards and provide clear, concise descriptions of changes. Format your commit message response as a single code block without any additional text.",
        },
        {
          role = "user",
          content = function()
            local branch_name = vim.fn.system("git branch --show-current"):gsub("\n", "")
            -- Get list of staged files for context
            local staged_files = vim.fn.system("git diff --staged --name-only"):gsub("\n$", "")
            -- Get the full diff of staged changes, not just the stats
            local git_diff = vim.fn.system "git diff --staged"

            -- Extract JIRA ticket ID from branch name if possible
            local jira_id = branch_name:match "[A-Z]+-[0-9]+" or ""

            return "Generate a commit message for my changes. Follow the below structure:\n"
              .. (jira_id ~= "" and jira_id or "{JIRA-TICKET-ID}")
              .. ": {Brief descriptive summary of changes in present tense}\n\n"
              .. "- {Detailed explanation of what changed and why}\n"
              .. "- {Additional bullet points for multiple changes if needed}\n\n"
              .. "Context:\n"
              .. "Current branch name: "
              .. branch_name
              .. "\n"
              .. "Files being committed:\n"
              .. staged_files
              .. "\n"
              .. "Diff of changes:\n```\n"
              .. git_diff
              .. "\n```\n\n"
              .. "Provide ONLY the commit message in a code block with no additional text. "
              .. "Use the present tense, be specific about the changes, and explain the 'why' when useful."
          end,
        },
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
    vectorcode = {
      opts = {
        add_tool = true,
      },
    },
  },
}
