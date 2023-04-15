--     ____      _ __    __
--    /  _/___  (_) /_  / /_  ______ _
--    / // __ \/ / __/ / / / / / __ `/
--  _/ // / / / / /__ / / /_/ / /_/ /
-- /___/_/ /_/_/\__(_)_/\__,_/\__,_/

require "core"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath }
  require("core.utils").FirstRunSetup()
end
vim.opt.rtp:prepend(lazypath)

require "plugins"

require "conf/thesaurus"
require "functions"
require "whichkeyconf"
require "statusline"
require "snippets"
require "cmpconf"
require "treesitter"
require "telescopeconf"
require "fzfconf"
require "rest"
require "barbarconf"
require "overseerconf"
require "gitsignsconf"
require "conf/colorscheme"
require("conf/vimwiki")
require "conf/misc"

if vim.fn.filereadable(vim.fn.expand "$HOME" .. "/.config/nvim/lua/Private/plugins/configs/dadbod.lua") then
  require("Private/plugins/configs/dadbod").setup()
end
