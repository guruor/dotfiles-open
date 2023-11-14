local utils = require "utils"
local vint = require "lsp/servers/efm-config/vint"
local luafmt = require "lsp/servers/efm-config/luafmt"
local golint = require "lsp/servers/efm-config/golint"
local goimports = require "lsp/servers/efm-config/goimports"
local black = require "lsp/servers/efm-config/black"
local isort = require "lsp/serversefm-config/isort"
local flake8 = require "lsp/serversefm-config/flake8"
local pylint = require "lsp/serversefm-config/pylint"
local autopep8 = require "lsp/serversefm-config/autopep8"
local mypy = require "lsp/serversefm-config/mypy"
local prettier = require "lsp/serversefm-config/prettier"
local eslint = require "lsp/serversefm-config/eslint"
local shellcheck = require "lsp/serversefm-config/shellcheck"
local terraform = require "lsp/serversefm-config/terraform"
-- local misspell = require "lsp/serversefm-config/misspell"
local proselint = require "lsp/serversefm-config/proselint"
local buf = require "lsp/serversefm-config/buf"
local sql_formatter = require "lsp/serversefm-config/sql-formatter"
-- https://github.com/mattn/efm-langserver
-- python = {black, isort, flake8, mypy},

local M = utils.merge({}, require "lsp.servers.common")

M.init_options = { documentFormatting = true }

M.filetypes = { "python", "javascript", "json", "lua", "vim", "markdown", "yaml", "proto", "go", "sh" }

M.settings = {
  rootMarkers = { ".git/" },
  languages = {
    -- ["="] = {misspell},
    vim = { vint },
    lua = { luafmt },
    go = { golint, goimports },
    python = { autopep8, flake8 },
    -- python = {black, isort, flake8, mypy},
    typescript = { prettier, eslint },
    javascript = { prettier, eslint },
    typescriptreact = { prettier, eslint },
    javascriptreact = { prettier, eslint },
    yaml = { prettier },
    json = { prettier },
    html = { prettier },
    scss = { prettier },
    css = { prettier },
    markdown = { prettier, proselint },
    sh = { shellcheck },
    tf = { terraform },
    proto = { buf },
    sql = { sql_formatter },
  },
}

return M
