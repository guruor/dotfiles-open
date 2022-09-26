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
      },
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
