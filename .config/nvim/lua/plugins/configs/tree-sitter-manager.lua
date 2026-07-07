local M = {}

M.border = vim.g.border_style -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
M.auto_install = true -- if enabled, install missing parsers when editing a new file
M.highlight = true -- treesitter highlighting is enabled by default

M.noauto_install = {
  "norg", -- Installation issue on arm Macs
}

M.ensure_installed = {
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
  "comment",
  "regex",
  "terraform",
}
M.languages = {
  dap_repl = {
    install_info = {
      url = "https://github.com/LiadOz/nvim-dap-repl-highlights",
      use_repo_queries = true,
    },
  },
  norg = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg",
      use_repo_queries = true,
    },
  },
  norg_meta = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
      use_repo_queries = true,
    },
  },

  powershell = {
    install_info = {
      url = "https://github.com/airbus-cert/tree-sitter-powershell",
      files = { "src/parser.c", "src/scanner.c" },
      branch = "main",
      generate_requires_npm = false,
      requires_generate_from_grammar = false,
    },
  },

  nu = {
    install_info = {
      url = "https://github.com/nushell/tree-sitter-nu",
      files = { "src/parser.c" },
      branch = "main",
    },
  },
}

return M
