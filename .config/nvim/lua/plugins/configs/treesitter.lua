-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
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
      "dockerfile",
      "make",
      "rust",
      -- "sql"
      },
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

-- If you don't like code blocks to be concealed use this to edit the highlight
-- https://github.com/MDeiml/tree-sitter-markdown/issues/68#issuecomment-1292108829
local ft_to_parser = require"nvim-treesitter.parsers".filetype_to_parsername
ft_to_parser.vimwiki = "markdown"

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

