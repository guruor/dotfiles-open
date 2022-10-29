require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
      "python",
      "go",
      "javascript",
      "typescript",
      "json",
      "markdown",
      "markdown_inline",
      "yaml",
      "toml",
      "http",
      "bash",
      "vim",
      "lua",
      "html",
      "scss",
      "css",
      "tsx",
      "rust"
      },
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
