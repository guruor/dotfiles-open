return {
  {
    -- DB query executer
    "kristijanhusak/vim-dadbod-ui",
    ft = "sql",
    dependencies = {
      {
        -- "tpope/vim-dadbod",
        "guruor/vim-dadbod",
        -- dir = "~/Workspace/vim-plugins/vim-dadbod",
        ft = "sql",
      },
      { "kristijanhusak/vim-dadbod-completion", ft = "sql" },
    },
    config = require("plugins.configs.dadbod").setup(),
  },
}
