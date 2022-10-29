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

-- Custom tree-sitter parser for http files, grammar includes rest-nvim format
-- https://github.com/rest-nvim/rest.nvim/issues/30
parser_config.http = {
  install_info = {
    url = 'https://github.com/rest-nvim/tree-sitter-http',
    revision = 'main',
    files = { 'src/parser.c'},
  },
  filetype = 'http',
}

