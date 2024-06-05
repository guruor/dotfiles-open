local utils = require "utils"

local M = {}

M.DiagnosticSignSetup = function()
  local signs = { ERROR = "", WARN = "", HINT = "", INFO = "" }
  -- local signs = { ERROR = "", WARN = "", HINT = "󰌵", INFO = "" }
  vim.diagnostic.config {
    underline = {
      severity = { max = vim.diagnostic.severity.INFO },
    },
    -- virtual_text = false,
    virtual_text = {
      -- source = "always",
      severity = { min = vim.diagnostic.severity.WARN },
      prefix = function(diagnostic)
        return signs[vim.diagnostic.severity[diagnostic.severity]]
      end,
    },
    virtual_improved = {
      current_line = "only",
    },
    float = {
      show_header = true,
      source = "always",
      border = vim.g.border_style,
      focusable = false,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
        [vim.diagnostic.severity.WARN] = "WarningMsg",
        [vim.diagnostic.severity.INFO] = "InfoMsg",
        [vim.diagnostic.severity.HINT] = "HintMsg",
      },
    },
  }
end

M.get_default_capabilities = function()
  -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  capabilities.offsetEncoding = { "utf-16" }

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.documentFormattingProvider = true
  capabilities.documentRangeFormattingProvider = true

  return capabilities
end

M.default_on_attach_func = function(_)
  utils.map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
  utils.map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
  utils.map("n", "K", ":lua vim.lsp.buf.hover()<CR>", { buffer = true })
  utils.map("n", "gr", "<Cmd>FzfLua lsp_references<CR>", { buffer = true })
  utils.map("n", "gi", "<Cmd>FzfLua lsp_implementations<CR>", { buffer = true })

  if not vim.g.should_enable_efm then
    local lazy_plugins = require("lazy.core.config").plugins
    if lazy_plugins["none-ls.nvim"] then
      require "lsp.none-ls"
    end
  end
end

M.default_on_attach_func_without_formatting_support = function(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  require("lsp.utils").default_on_attach_func(client)
end

return M
