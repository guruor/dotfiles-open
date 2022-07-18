require "lsp.handlers"
local lspconfig = require "lspconfig"
local utils = require "utils"
local M = {}

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

vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

local on_attach = function(client)
    utils.map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {buffer = true})
    utils.map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', {buffer = true})
    utils.map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {buffer = true})
    utils.map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {buffer = true})
    utils.map('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', {buffer = true})
    utils.map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {buffer = true})
    utils.map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {buffer = true})
    require("lsp.lsp-format").on_attach(client)
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
    for _, lsp in pairs(vim.lsp.buf_get_clients()) do
        table.insert(servers, { name = lsp.name, id = lsp.id })
    end
    _G.P(servers)
end

-- https://github.com/golang/tools/tree/master/gopls
lspconfig.gopls.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}

-- https://github.com/palantir/python-language-server
-- lspconfig.pyls.setup {
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
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}

-- https://github.com/pappasam/jedi-language-server
-- lspconfig.jedi_language_server.setup {
-- on_attach = function(client)
-- client.resolved_capabilities.document_formatting = false
-- on_attach(client)
-- end
-- }

-- lspconfig.rls.setup {on_attach = on_attach}

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
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
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
lspconfig.sumneko_lua.setup {
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
lspconfig.vimls.setup {on_attach = on_attach}

-- https://github.com/vscode-langservers/vscode-json-languageserver
lspconfig.jsonls.setup {on_attach = on_attach, cmd = {"vscode-json-languageserver", "--stdio"}}

-- https://github.com/redhat-developer/yaml-language-server
lspconfig.yamlls.setup {on_attach = on_attach}

-- https://github.com/joe-re/sql-language-server
lspconfig.sqlls.setup {on_attach = on_attach}

-- https://github.com/vscode-langservers/vscode-css-languageserver-bin
-- https://github.com/hrsh7th/vscode-langservers-extracted
-- npm i -g vscode-langservers-extracted, this will provide below LSPs
-- vscode-html-language-server
-- vscode-css-language-server
-- vscode-json-language-server
-- vscode-eslint-language-server
lspconfig.cssls.setup {on_attach = on_attach}

-- https://github.com/vscode-langservers/vscode-html-languageserver-bin
lspconfig.html.setup {on_attach = on_attach}

-- https://github.com/bash-lsp/bash-language-server
lspconfig.bashls.setup {on_attach = on_attach}

-- https://github.com/rcjsuen/dockerfile-language-server-nodejs
lspconfig.dockerls.setup {on_attach = on_attach}

-- https://github.com/hashicorp/terraform-ls
lspconfig.terraformls.setup {on_attach = on_attach, cmd = {"terraform-ls", "serve"}, filetypes = {"tf"}}

local vint = require "efm/vint"
local luafmt = require "efm/luafmt"
local golint = require "efm/golint"
local goimports = require "efm/goimports"
local black = require "efm/black"
local isort = require "efm/isort"
local flake8 = require "efm/flake8"
local pylint = require "efm/pylint"
local autopep8 = require "efm/autopep8"
local mypy = require "efm/mypy"
local prettier = require "efm/prettier"
local eslint = require "efm/eslint"
local shellcheck = require "efm/shellcheck"
local terraform = require "efm/terraform"
-- local misspell = require "efm/misspell"
local proselint = require "efm/proselint"
-- https://github.com/mattn/efm-langserver
-- python = {black, isort, flake8, mypy},
lspconfig.efm.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        client.resolved_capabilities.document_range_formatting = true
        on_attach(client)
    end,
    init_options = {documentFormatting = true},
    filetypes = {"python", "javascript", "json", "lua", "vim", "markdown", "yaml"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            -- ["="] = {misspell},
            vim = {vint},
            lua = {luafmt},
            go = {golint, goimports},
            python = {autopep8, flake8},
            -- python = {black, isort, flake8, mypy},
            typescript = {prettier, eslint},
            javascript = {prettier, eslint},
            typescriptreact = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            yaml = {prettier},
            json = {prettier},
            html = {prettier},
            scss = {prettier},
            css = {prettier},
            markdown = {prettier, proselint},
            sh = {shellcheck},
            tf = {terraform}
        }
    }
}

lspconfig.clangd.setup {on_attach = on_attach}

return M
