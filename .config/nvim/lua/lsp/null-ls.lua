local null_ls = require("null-ls")

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

local home_dir=os.getenv("HOME")
local cbfmt_config_file = home_dir .. "/.config/cbfmt/cbfmt.toml"
local cbfmt = h.make_builtin({
    name = "cbfmt",
    meta = {
        url = "https://github.com/lukas-reineke/cbfmt",
        description = "A tool to format codeblocks inside markdown and org documents.",
    },
    method = FORMATTING,
    filetypes = { "markdown", "org", "vimwiki" },
    generator_opts = {
        command = "cbfmt",
        args = {
            "--stdin-filepath",
            "$FILENAME",
            "--best-effort",
            "--config",
            cbfmt_config_file,
        },
        to_stdin = true,
    },
    factory = h.formatter_factory,
})

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion

null_ls.setup({
    debug = true,
    sources = {
        cbfmt,
        formatting.stylua,
        formatting.prettierd,

        formatting.autopep8,
        formatting.isort,

        formatting.gofmt,
        formatting.goimports,
        formatting.gofumpt,
        formatting.golines,

        formatting.pg_format,
        -- formatting.sql_formatter,

        diagnostics.eslint,
        completion.spell,
    },
})
