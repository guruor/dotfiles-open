local schemastore = require "schemastore"

local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

M.settings = {
  yaml = {
    keyOrdering = false,
    schemas = schemastore.yaml.schemas(),
    schemaStore = {
      -- You must disable built-in schemaStore support if you want to use
      -- this plugin and its advanced options like `ignore`.
      enable = false,
      -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      url = "",
    },
    validate = { enable = true },
    hover = true,
    completion = true,
  },
}

return M
