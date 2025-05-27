local utils = require "utils"

-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
--
-- This is the load sequence followed by lazy, can be seen by doing `:h lazy.nvim-lazy.nvim-startup-sequence`:
--
-- 1. All the plugins’ `init()` functions are executed
-- 2. All plugins with `lazy=false` are loaded. This includes sourcing `/plugin` and `/ftdetect` files. (`/after` will not be sourced yet)
-- 3. All files from `/plugin` and `/ftdetect` directories in you rtp are sourced (excluding `/after`)
-- 4. All `/after/plugin` files are sourced (this includes `/after` from plugins)
local default_plugins = {}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

-- List of all default plugins & their definitions
local colorscheme_plugins = require "plugins.colorscheme"
local treesitter_plugins = require "plugins.treesitter"
local ui_plugins = require "plugins.ui"
local navigation_plugins = require "plugins.navigation"
local editor_plugins = require "plugins.editor"
local git_plugins = require "plugins.git"
local util_plugins = require "plugins.util"
local journal_plugins = require "plugins.journal"
local db_plugins = require "plugins.db"
local rest_plugins = require "plugins.rest"
local ai_plugins = require "plugins.ai"
local csv_plugins = require "plugins.csv"

-- Merge all plugin tables into one
local plugins = utils.merge_tables(default_plugins, colorscheme_plugins, treesitter_plugins, ui_plugins)
plugins = utils.merge_tables(plugins, navigation_plugins, editor_plugins)
plugins = utils.merge_tables(plugins, git_plugins, util_plugins, journal_plugins, csv_plugins)
plugins = utils.merge_tables(plugins, db_plugins, rest_plugins)
plugins = utils.merge_tables(plugins, ai_plugins)

if vim.g.initlsp == 1 then
  local lsp_plugins = require "plugins.lsp"
  local dap_plugins = require "plugins.dap"
  local test_plugins = require "plugins.test"
  plugins = utils.merge_tables(plugins, lsp_plugins, dap_plugins, test_plugins)
end

require("lazy").setup(plugins, config.lazy_nvim)
