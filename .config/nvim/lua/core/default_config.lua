local M = {}

M.options = {}

M.plugins = "" -- path i.e "custom.plugins" -> custom/plugins.lua only and not custom/plugins/init.lua!!!!

M.lazy_nvim = require "plugins.configs.lazy_nvim" -- config for lazy.nvim startup options

-- these are default mappings, check core.mappings for table structure
M.mappings = require "core.mappings"

return M
