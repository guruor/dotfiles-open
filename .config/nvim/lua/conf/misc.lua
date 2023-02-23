require('Comment').setup()
require 'colorizer'.setup()
local smartcolumn_config = {
   colorcolumn = 120,
   disabled_filetypes = { "help", "text", "markdown" },
}

require("smartcolumn").setup(smartcolumn_config)
