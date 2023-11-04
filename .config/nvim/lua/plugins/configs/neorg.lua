local M = {}

M.options = {
  load = {
    ["core.defaults"] = {},
    ["core.neorgcmd"] = {},
    ["core.summary"] = {},
    ["core.journal"] = {},
    ["core.autocommands"] = {},
    ["core.presenter"] = {
      config = {
        zen_mode = "zen-mode",
      },
    },
    ["core.export"] = { config = {} },
    ["core.export.markdown"] = { config = {} },
    ["core.integrations.treesitter"] = { config = {} },
    ["core.ui"] = {},
    ["core.ui.calendar"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          work = "~/Dropbox/Neorg/Work",
          personal = "~/Dropbox/Neorg/Personal",
        },
        default_workspace = "work",
      },
    },
    ["core.qol.todo_items"] = {
      config = {
        create_todo_items = true,
        create_todo_parents = true,
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
  },
}

return M
