local utils = require "utils"

return {
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = require("plugins.configs.misc").chatgpt,
    config = function(_, opts)
      require("chatgpt").setup(opts)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    dependencies = { "zbirenbaum/copilot-cmp" },
    config = utils.load_config "configs.copilot",
    event = "InsertEnter",
    enabled = false,
  },
}
