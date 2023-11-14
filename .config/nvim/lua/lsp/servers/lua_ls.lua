local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

M.on_attach = require("lsp.utils").default_on_attach_func_without_formatting_support

M.cmd = { "lua-language-server" }

local function get_lua_runtime()
  local result = {}
  for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
    local lua_path = path .. "/lua/"
    if vim.fn.isdirectory(lua_path) then
      result[lua_path] = true
    end
  end
  result[vim.fn.expand "$VIMRUNTIME/lua"] = true
  result[vim.fn.expand "~/build/neovim/src/nvim/lua"] = true

  return result
end
M.settings = {
  Lua = {
    runtime = { version = "LuaJIT" },
    completion = { keywordSnippet = "Disable" },
    diagnostics = {
      enable = true,
      globals = {
        -- Neovim
        "vim", -- Busted
        "describe",
        "it",
        "before_each",
        "after_each",
        "teardown",
        "pending", -- packer
        "use",
      },
      workspace = { library = get_lua_runtime(), maxPreload = 1000, preloadFileSize = 1000 },
    },
  },
}

return M
