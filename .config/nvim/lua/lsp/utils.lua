local utils = require "utils"

local M = {}

M.DiagnosticSignSetup = function()
  local signs = { "Error", "Warn", "Hint", "Info" }
  for i in pairs(signs) do
    local hl = "DiagnosticSign" .. signs[i]
    -- vim.fn.sign_define(hl, { text = "•", texthl = hl, linehl='', numhl = '' })
    vim.fn.sign_define(hl, { text = "", texthl = "", linehl = "", numhl = hl })
  end
end

M.LspKindSetup = function()
  vim.lsp.protocol.CompletionItemKind = {
    Text = " [text]",
    Method = " [method]",
    Function = " [function]",
    Constructor = " [constructor]",
    Field = "ﰠ [field]",
    Variable = " [variable]",
    Class = " [class]",
    Interface = " [interface]",
    Module = " [module]",
    Property = " [property]",
    Unit = " [unit]",
    Value = " [value]",
    Enum = " [enum]",
    Keyword = " [key]",
    Snippet = "﬌ [snippet]",
    Color = " [color]",
    File = " [file]",
    Reference = " [reference]",
    Folder = " [folder]",
    EnumMember = " [enum member]",
    Constant = " [constant]",
    Struct = " [struct]",
    Event = "⌘ [event]",
    Operator = " [operator]",
    TypeParameter = " [type]",
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
  utils.map("n", "gd", "<Cmd>Lspsaga goto_definition<CR>", { buffer = true })
  utils.map("n", "gD", "<Cmd>Lspsaga goto_type_definition<CR>", { buffer = true })
  utils.map("n", "K", "<Cmd>Lspsaga hover_doc<CR>", { buffer = true })
  utils.map("n", "gr", "<Cmd>Lspsaga finder<CR>", { buffer = true })

  if not vim.g.should_enable_efm then
    -- print("Enabling null-ls")
    require "lsp.null-ls"
  end
  -- null-ls provides support for formatting, but still keeping formatter.nvim as backup
  -- It also mimics range formatting with hack of using temporary buffer
  require "lsp.formatter"
end

M.default_on_attach_func_without_formatting_support = function(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  require("lsp.utils").default_on_attach_func(client)
end

return M