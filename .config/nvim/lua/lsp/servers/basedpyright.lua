local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

-- https://github.com/golang/tools/tree/master/gopls
M.on_attach = require("lsp.utils").default_on_attach_func_without_formatting_support
M.settings = {
  basedpyright = {
    -- Using Ruff's import organizer
    disableOrganizeImports = true,
    disableTaggedHints = true,
    analysis = {
      typeCheckingMode = "standard",
      diagnosticMode = "openFilesOnly",
      useLibraryCodeForTypes = true,
    },
  },
  python = {},
}

return M
