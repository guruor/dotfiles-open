local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

local function on_attach_func_without_pyright_features(client)
  -- Disable hover in favor of Pyright
  client.server_capabilities.hoverProvider = false
  require("lsp.utils").default_on_attach_func(client)
end

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
M.on_attach = on_attach_func_without_pyright_features

M.init_options = {
  settings = {
    -- Any extra CLI arguments for `ruff` go here.
    args = {},
  },
}

return M
