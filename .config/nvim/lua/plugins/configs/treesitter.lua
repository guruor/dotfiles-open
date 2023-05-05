-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

local M = {}

M.options = {
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
    "sql",
    "query",
  },
  context_commentstring = {
    enable_autocmd = false,
    enable = true,
    config = {
      javascript = {
        __default = "// %s",
        jsx_element = "{/* %s */}",
        jsx_fragment = "{/* %s */}",
        jsx_attribute = "// %s",
        comment = "// %s",
      },
      typescript = { __default = "// %s", __multiline = "/* %s */" },
      http = { __default = "# %s", __multiline = "<!-- %s -->" },
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
}

M.additional_setup = function()
  -- If you don't like code blocks to be concealed use this to edit the highlight
  -- https://github.com/MDeiml/tree-sitter-markdown/issues/68#issuecomment-1292108829
  vim.treesitter.language.register("markdown", "vimwiki")
  vim.treesitter.language.register('markdown', 'chatgpt')

  -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  -- Custom tree-sitter parser for http files, grammar includes rest-nvim format
  -- Tree sitter by default installs this syntax only for http filetype
  -- https://github.com/rest-nvim/rest.nvim/issues/30
  -- parser_config.http = {
  --   install_info = {
  --     url = 'https://github.com/rest-nvim/tree-sitter-http',
  --     -- revision = 'main',
  --     revision = 'bfddd16b1cf78e0042fd1f6846a179f76a254e20',
  --     files = { 'src/parser.c'},
  --   },
  --   filetype = 'http',
  -- }
end
return M
