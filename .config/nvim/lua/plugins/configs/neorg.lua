local utils = require "utils"
local neorgDir = vim.fn.expand "$NEORG_DIR"

local M = {}

local defaultModuleConfig = {
  -- https://github.com/nvim-neorg/neorg/wiki#default-modules
  ["core.defaults"] = {},
  ["core.clipboard.code-blocks"] = {},
  ["core.esupports.hop"] = {},
  -- 'empty' creates meta for new files
  ["core.esupports.metagen"] = { config = { type = "empty" } },
  -- Continue to iterator item at same nested level, default key is <M-CR> (Alt + Enter)
  -- Check: core.itero.next-iteration
  ["core.itero"] = {},
  ["core.journal"] = {
    config = {
      workspace = "work",
      use_template = false, -- Using external.templates below
      strategy = "nested",
    },
  },
  -- magnifies code blocks and allows you to edit them in a separate buffer
  ["core.looking-glass"] = {},
  ["core.keybinds"] = {
    -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
    config = {
      default_keybinds = true,
      neorg_leader = "<Leader>n",
      -- hook = function(keybinds)
      --   keybinds.map("norg", "n", "o", "core.itero.next-iteration", "<CR>")
      -- end
    },
  },
  ["core.qol.toc"] = {},
  ["core.qol.todo_items"] = {},
}

local otherModuleConfig = {
  ["core.dirman"] = {
    config = {
      autodetect = true,
      workspaces = {
        work = neorgDir .. "/Work",
        personal = neorgDir .. "/Personal",
      },
      default_workspace = "work",
    },
  },
  ["core.concealer"] = {
    config = {
      icons = {
        code_block = {
          conceal = true,
        },
      },
    },
  },
  ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
  ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
  ["core.summary"] = {},
  ["core.export"] = {},
  ["core.export.markdown"] = {},
  ["core.ui.calendar"] = {},
}

local externalModuleConfig = {
  -- treesitter-context with concealing support
  ["external.context"] = {},
  -- Extension to use template with dynamic values and lua snippets support
  ["external.templates"] = {
    config = {
      templates_dir = { neorgDir .. "/templates" },
    },
  },
}

local finalConfig = {}
finalConfig = utils.merge(finalConfig, defaultModuleConfig)
finalConfig = utils.merge(finalConfig, otherModuleConfig)
finalConfig = utils.merge(finalConfig, externalModuleConfig)

-- P(finalConfig)
M.options = {
  load = finalConfig,
}

return M
