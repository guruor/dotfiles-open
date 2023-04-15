require "plugins.configs.thesaurus"
require "plugins.configs.whichkey"
require "plugins.configs.statusline"
require "plugins.configs.snippets"
require "plugins.configs.cmp"
require "plugins.configs.treesitter"
require "plugins.configs.telescope"
require "plugins.configs.fzf"
require "plugins.configs.rest"
require "plugins.configs.barbar"
require "plugins.configs.overseer"
require "plugins.configs.gitsigns"
require "plugins.configs.colorscheme"
require "plugins.configs.vimwiki"
require "plugins.configs.misc"

if vim.fn.filereadable(vim.fn.expand "$HOME" .. "/.config/nvim/lua/Private/plugins/configs/dadbod.lua") then
  require("Private/plugins/configs/dadbod").setup()
end
