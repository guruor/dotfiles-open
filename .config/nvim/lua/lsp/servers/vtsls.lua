local schemastore = require "schemastore"

local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

M.settings = {
  vtsls = {
    experimental = {
      completion = {
        enableServerSideFuzzyMatch = true,
        entriesLimit = 50,
      },
    },
  },
}

return M
