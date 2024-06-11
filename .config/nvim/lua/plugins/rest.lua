local utils = require "utils"

return {
  {
    -- Rest client
    -- "rest-nvim/rest.nvim",
    "guruor/rest.nvim",
    -- branch = "response_body_stored_updated",
    branch = "response_body_stored",
    ft = "http",
    config = utils.load_config "configs.rest",
  },
  {
    "NachoNievaG/atac.nvim",
    dependencies = { "akinsho/toggleterm.nvim" },
    config = function()
      local atacMainDir = os.getenv "ATAC_MAIN_DIR"
      require("atac").setup {
        dir = atacMainDir,
      }
    end,
    cmd = { "Atac" },
  },
}
