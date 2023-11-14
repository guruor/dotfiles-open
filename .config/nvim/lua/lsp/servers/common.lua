local M = {}

-- Default setting for servers, will be overidden for specific server if needed
M.capabilities = require("lsp.utils").get_default_capabilities()
M.on_attach = require("lsp.utils").default_on_attach_func
M.settings = {}

return M
