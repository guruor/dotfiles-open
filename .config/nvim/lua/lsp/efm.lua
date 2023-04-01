local vint = require("lsp/efm-config/vint")
local luafmt = require("lsp/efm-config/luafmt")
local golint = require("lsp/efm-config/golint")
local goimports = require("lsp/efm-config/goimports")
local black = require("lsp/efm-config/black")
local isort = require("lsp/efm-config/isort")
local flake8 = require("lsp/efm-config/flake8")
local pylint = require("lsp/efm-config/pylint")
local autopep8 = require("lsp/efm-config/autopep8")
local mypy = require("lsp/efm-config/mypy")
local prettier = require("lsp/efm-config/prettier")
local eslint = require("lsp/efm-config/eslint")
local shellcheck = require("lsp/efm-config/shellcheck")
local terraform = require("lsp/efm-config/terraform")
-- local misspell = require "lsp/efm-config/misspell"
local proselint = require("lsp/efm-config/proselint")
local buf = require("lsp/efm-config/buf")
local sql_formatter = require("lsp/efm-config/sql-formatter")
-- https://github.com/mattn/efm-langserver
-- python = {black, isort, flake8, mypy},
--

local M = {}

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
