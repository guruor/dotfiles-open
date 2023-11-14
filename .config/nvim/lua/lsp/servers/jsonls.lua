local schemastore = require "schemastore"

local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

M.settings = {
  json = {
    schemas = schemastore.json.schemas(),
    validate = { enable = true },
    hover = true,
    completion = true,
  },
}

return M
