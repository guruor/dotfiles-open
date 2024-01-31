-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

local M = {}

M.options = {
  auto_install = true,
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  autotag = {
    enable = true,
    filetypes = {
      "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue",
      "tsx", "jsx", "rescript", "css", "lua", "xml", "php", "markdown",
    },
  },
  matchup = {
    enable = true,
    enable_quotes = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
  },
  ensure_installed = {
    "python",
    "go",
    "javascript",
    "typescript",
    "json",
    "markdown",
    "markdown_inline",
    "norg",
    "norg_meta",
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
    "dap_repl",
    "comment",
    "regex"
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
  vim.treesitter.language.register("markdown", "chatgpt")

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
