local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

-- https://github.com/golang/tools/tree/master/gopls
M.on_attach = require("lsp.utils").default_on_attach_func_without_formatting_support
M.settings = {
  pyright = {
    -- Using Ruff's import organizer
    disableOrganizeImports = true,
  },
  python = {
    analysis = {
      -- Ignore all files for analysis to exclusively use Ruff for linting
      ignore = { "*" },
      -- typeCheckingMode = 'off', -- Using mypy
    },
  },
}

return M
