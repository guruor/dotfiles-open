--     ____      _ __    __
--    /  _/___  (_) /_  / /_  ______ _
--    / // __ \/ / __/ / / / / / __ `/
--  _/ // / / / / /__ / / /_/ / /_/ /
-- /___/_/ /_/_/\__(_)_/\__,_/\__,_/

require "core"

local homeDir = vim.fn.expand "$HOME"
local autoloadPath = homeDir .. "/.config/nvim/autoload"
local plugpath = autoloadPath .. "/plug.vim"
if not vim.fn.filereadable(plugpath) then
  print "Downloading junegunn/vim-plug to manage plugins..."
  vim.cmd("silent !mkdir -p " .. autoloadPath)
  vim.cmd('silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" >' .. plugpath)
  vim.cmd "autocmd VimEnter * PlugInstall"
  require("core.utils").FirstRunSetup()
end

require "plugins/init_plug"
require "plugins/configs"
