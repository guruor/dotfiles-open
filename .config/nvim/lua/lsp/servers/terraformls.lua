local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

M.on_attach = function(client, bufnr)
  -- Disable semantic tokens if they are freezing the buffer
  if client.name == "terraformls" or client.name == "tflint" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

return M
