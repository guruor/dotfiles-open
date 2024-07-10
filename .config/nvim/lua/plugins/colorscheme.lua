return {
  {
    "linrongbin16/colorbox.nvim",
    lazy = false,
    priority = 1000,
    -- required by 'mcchrish/zenbones.nvim'
    dependencies = "rktjmp/lush.nvim",
    build = function()
      require("colorbox").update()
    end,
    config = function()
      require "plugins.configs.colorscheme"
      require "plugins.configs.colorboxconf"
      -- Needed this to clear duplicate statusline after colorscheme change
      vim.g.tpipeline_clearstl = 1
    end,
  },
  {
    "aklt/plantuml-syntax",
    ft = "plantuml",
  },
}
