local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

M.settings = {
  ["rust-analyzer"] = {
    assist = {
      importMergeBehavior = "last",
      importPrefix = "by_self",
    },
    cargo = {
      loadOutDirsFromCheck = true,
    },
    procMacro = {
      enable = true,
    },
  },
}

return M
