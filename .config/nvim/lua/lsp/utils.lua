local utils = require "utils"

local M = {}

M.DiagnosticSignSetup = function()
  local signs = { ERROR = "", WARN = "", HINT = "", INFO = "" }
  -- local signs = { ERROR = "", WARN = "", HINT = "󰌵", INFO = "" }
  local config = {
    underline = {
      severity = { max = vim.diagnostic.severity.INFO },
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

  if M.diagnostic_virtual_text_enabled then
    config.virtual_text = {
      -- Your specific virtual text configuration when enabled
      -- source = "always",
      severity = { min = vim.diagnostic.severity.WARN },
      prefix = function(diagnostic)
        return signs[vim.diagnostic.severity[diagnostic.severity]]
      end,
    }
  else
    config.virtual_text = false
  end

  vim.diagnostic.config(config)
end

-- Initialize the virtual text state
M.diagnostic_virtual_text_enabled = false

-- Function to toggle virtual text
M.toggle_diagnostic_virtual_text = function()
  M.diagnostic_virtual_text_enabled = not M.diagnostic_virtual_text_enabled
  M.DiagnosticSignSetup() -- Re-apply the diagnostic config
  vim.notify("Diagnostic virtual text " .. (M.diagnostic_virtual_text_enabled and "enabled" or "disabled"))
end

M.get_default_capabilities = function()
  -- The nvim-cmp/blink almost supports LSP's capabilities so You should advertise it to LSP servers..
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

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
  utils.map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
  utils.map("n", "grn", "<Cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
  utils.map("n", "grr", "<Cmd>FzfLua lsp_references<CR>", { buffer = true })
  utils.map("n", "gra", "<Cmd>FzfLua lsp_code_actions<CR>", { buffer = true })
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
