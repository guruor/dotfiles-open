-- Look for server configurations here
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

require "lsp.handlers"
local lspconfig = require "lspconfig"
local utils = require "utils"
local M = {}

-- Adding some lsp related config from kickstart.nvim
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
require 'lsp.mason-tool-installer'
require"fidget".setup{}
-- Setup neovim lua configuration
require('neodev').setup()
local mason_lspconfig = require 'mason-lspconfig'

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

M.symbol_kind_icons = {
    Function = "",
    Method = "",
    Variable = "",
    Constant = "",
    Interface = "練",
    Field = "ﰠ",
    Property = "",
    Struct = "",
    Enum = "",
    Class = "",
    File = "",
    Module = "",
    Namespace = "",
    Package = "",
    Constructor = "",
    String = "",
    Number = "",
    Boolean = "◩",
    Array = "",
    Object = "",
    Key = "",
    Null = "ﳠ",
    EnumMember = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

M.symbol_kind_colors = {
    Function = "green",
    Method = "green",
    Variable = "blue",
    Constant = "red",
    Interface = "cyan",
    Field = "blue",
    Property = "blue",
    Struct = "cyan",
    Enum = "yellow",
    Class = "magenta",
}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

-- Single flag to toggle efm-langserver and null-ls
-- Both serves the same purpose of providing support for external linters and formatters
-- As of now using null-ls as first priority because it provides support for range-formatting as well
vim.g.should_enable_efm = false

local on_attach = function(client)
    utils.map('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>', {buffer = true})
    utils.map('n', 'gD', '<Cmd>Lspsaga goto_type_definition<CR>', {buffer = true})
    utils.map('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', {buffer = true})
    utils.map('n', 'gr', '<Cmd>Lspsaga lsp_finder<CR>', {buffer = true})

    if not vim.g.should_enable_efm then
        -- print("Enabling null-ls")
        require("lsp.null-ls")
    end
    -- null-ls provides support for formatting, but still keeping formatter.nvim as backup
    -- It also mimics range formatting with hack of using temporary buffer
    require("lsp.formatter")
end

function _G.activeLSP()
    local servers = {}
    for _, lsp in pairs(vim.lsp.get_active_clients()) do
        table.insert(servers, { name = lsp.name, id = lsp.id })
    end
    _G.P(servers)
end

function _G.bufferActiveLSP()
    local servers = {}
    for _, lsp in pairs(vim.lsp.get_active_clients()) do
        table.insert(servers, { name = lsp.name, id = lsp.id })
    end
    _G.P(servers)
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    clangd = {},
    gopls = {},
    pyright = {},
    rust_analyzer = {},
    vimls = {},
    jsonls = {},
    yamlls = {},
    cssls = {},
    html = {},
    bashls = {},
    dockerls = {},
    terraformls = {},
    tsserver = {},
    lua_ls = {},
    sqlls = {},
    -- bufls = {},
}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

if vim.g.should_enable_efm then
    -- print("Enabling efm-langserver")
    local efm_lsp = require("lsp.efm")
    lspconfig.efm.setup({
        capabilities = capabilities,
        on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = true
            client.server_capabilities.documentRangeFormattingProvider = true
            on_attach(client)
        end,
        init_options = { documentFormatting = true },
        filetypes = efm_lsp.filetypes,
        settings = efm_lsp.settings,
    })
else
end

-- https://github.com/golang/tools/tree/master/gopls
lspconfig.gopls.setup {
    capabilities = capabilities,
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client)
    end
}

-- https://github.com/palantir/python-language-server
-- lspconfig.pyls.setup {
--    capabilities = capabilities,
--     on_attach = on_attach,
--     settings = {
--         pyls = {
--             plugins = {
--                 pycodestyle = {
--                     enabled = false,
--                     ignore = {
--                         "E501"
--                     }
--                 }
--             }
--         }
--     }
-- }

-- https://github.com/microsoft/pyright
lspconfig.pyright.setup {
    capabilities = capabilities,
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client)
    end
}

-- https://github.com/pappasam/jedi-language-server
-- lspconfig.jedi_language_server.setup {
--    capabilities = capabilities,
-- on_attach = function(client)
-- client.server_capabilities.documentFormattingProvider = false
-- on_attach(client)
-- end
-- }

-- lspconfig.rls.setup {
    -- capabilities = capabilities,
    -- on_attach = on_attach
-- }

lspconfig.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

-- https://github.com/theia-ide/typescript-language-server
lspconfig.tsserver.setup {
    capabilities = capabilities,
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        -- require"nvim-lsp-ts-utils".setup {}
        on_attach(client)
    end
}

local function get_lua_runtime()
    local result = {}
    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
        local lua_path = path .. "/lua/"
        if vim.fn.isdirectory(lua_path) then result[lua_path] = true end
    end
    result[vim.fn.expand("$VIMRUNTIME/lua")] = true
    result[vim.fn.expand("~/build/neovim/src/nvim/lua")] = true

    return result
end

lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {"lua-language-server"},
    settings = {
        Lua = {
            runtime = {version = "LuaJIT"},
            completion = {keywordSnippet = "Disable"},
            diagnostics = {
                enable = true,
                globals = {
                    -- Neovim
                    "vim", -- Busted
                    "describe", "it", "before_each", "after_each", "teardown", "pending", -- packer
                    "use"
                },
                workspace = {library = get_lua_runtime(), maxPreload = 1000, preloadFileSize = 1000}
            }
        }
    }
}

-- https://github.com/iamcco/vim-language-server
lspconfig.vimls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

-- https://github.com/vscode-langservers/vscode-json-languageserver
lspconfig.jsonls.setup {
    capabilities = capabilities,
    on_attach = on_attach, cmd = {"vscode-json-languageserver", "--stdio"}
}

-- https://github.com/redhat-developer/yaml-language-server
lspconfig.yamlls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

-- https://github.com/joe-re/sql-language-server
lspconfig.sqlls.setup {on_attach = on_attach}

-- https://github.com/vscode-langservers/vscode-css-languageserver-bin
-- https://github.com/hrsh7th/vscode-langservers-extracted
-- npm i -g vscode-langservers-extracted, this will provide below LSPs
-- vscode-html-language-server
-- vscode-css-language-server
-- vscode-json-language-server
-- vscode-eslint-language-server
lspconfig.cssls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

-- https://github.com/vscode-langservers/vscode-html-languageserver-bin
lspconfig.html.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

-- https://github.com/bash-lsp/bash-language-server
lspconfig.bashls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

-- https://github.com/rcjsuen/dockerfile-language-server-nodejs
lspconfig.dockerls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

-- https://github.com/hashicorp/terraform-ls
lspconfig.terraformls.setup {
    capabilities = capabilities,
    on_attach = on_attach, cmd = {"terraform-ls", "serve"}, filetypes = {"tf"}
}

-- https://github.com/bufbuild/buf-language-server
-- go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
lspconfig.bufls.setup {
    capabilities = capabilities,
    on_attach = on_attach, cmd = {"bufls", "serve"}, filetypes = {"proto"}
}


lspconfig.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach, cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
}



-- Neovim's built-in LSP with a highly performant UI.
require("lspsaga").setup()

-- " LspSaga remove border highlighting
-- " highlight SagaBorder guifg=#ffffff guibg=None
vim.api.nvim_set_hl(0, 'SagaBorder', { fg = "#ffffff", bg = nil })


return M
