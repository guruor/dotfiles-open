local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Use this doc to extend existing formatters
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
local cbfmt_config_file = os.getenv "HOME" .. "/.config/cbfmt/cbfmt.toml"
null_ls.setup {
  debug = true,
  sources = {
    -- Rust based generic formatter, really fast and extensible with wasm plugins
    -- It lacks range formatting as of now,
    formatting.dprint.with {
      extra_filetypes = { "vimwiki" },
    },
    -- Using cbfmt config file to format the codeblocks
    -- Added support for vimwiki code block formatting in cbfmt formatter
    formatting.cbfmt.with {
      extra_filetypes = { "vimwiki" },
      extra_args = { "--config", cbfmt_config_file },
    },
    formatting.stylua,
    -- prettierd already support a lot of filetypes
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting/prettierd.lua
    -- Extending the formatting for `vimwiki` filetype
    formatting.prettier.with {
      extra_filetypes = { "vimwiki" },
    },

    formatting.autopep8,
    formatting.isort,

    formatting.gofmt,
    formatting.goimports,
    formatting.gofumpt,
    formatting.golines,

    formatting.pg_format,
    -- formatting.sql_formatter,

    diagnostics.eslint,
  },
}
