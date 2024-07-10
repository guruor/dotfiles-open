local utils = require "utils"

return {
  {
    "nvim-neotest/neotest",
    keys = { { "<leader>rt" } },
    dependencies = {
      "vim-test/vim-test",
      "nvim-neotest/neotest-vim-test",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "KaiSpencer/neotest-vitest",
      "haydenmeade/neotest-jest",
      "nvim-neotest/neotest-plenary",
    },
    config = utils.load_config('configs.neotest'),
  },
}
