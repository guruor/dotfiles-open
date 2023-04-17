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
