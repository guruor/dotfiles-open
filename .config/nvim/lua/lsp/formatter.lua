-- Utilities for creating configurations
local util = require("formatter.util")

local home_dir=os.getenv("HOME")
local cbfmt_config_file = util.escape_path(home_dir .. "/.config/cbfmt/cbfmt.toml")
local current_buffer_path = util.escape_path(util.get_current_buffer_file_path())

-- cbfmt --write --best-effort --config ~/.config/cbfmt/cbfmt.toml  ./diary/2023-03-26.md
local cbfmt_config = {
    exe = "cbfmt",
    args = {
        "--write",
        "--best-effort",
        "--parser",
        "markdown",
        "--config",
        cbfmt_config_file,
        current_buffer_path
    },
    stdin = false,
}

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
        go = {
            require("formatter.filetypes.go").gofmt,
            require("formatter.filetypes.go").goimports,
            require("formatter.filetypes.go").gofumpt,
            require("formatter.filetypes.go").gofumports,
            require("formatter.filetypes.go").golines,
        },
        python = { require("formatter.filetypes.python").black, require("formatter.filetypes.python").isort },
        json = { require("formatter.filetypes.json").prettierd },
        markdown = { require("formatter.filetypes.markdown").prettierd, cbfmt_config },
        vimwiki = { require("formatter.filetypes.markdown").prettierd, cbfmt_config },
        javascript = { require("formatter.filetypes.javascript").prettierd },
        typescript = { require("formatter.filetypes.typescript").prettierd },
        rust = { require("formatter.filetypes.rust").rustfmt },
        sh = { require("formatter.filetypes.sh").shfmt },
        cmake = { require("formatter.filetypes.cmake").cmakeformat },
        css = { require("formatter.filetypes.css").prettierd },
        html = { require("formatter.filetypes.html").prettierd },
        sql = { require("formatter.filetypes.sql").pgformat },
        toml = { require("formatter.filetypes.toml").taplo },
        terraform = { require("formatter.filetypes.terraform").terraformfmt },
        yaml = { require("formatter.filetypes.yaml").prettierd },
        -- Formatter configurations for filetype "lua" go here
        -- and will be executed in order
        lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require("formatter.filetypes.lua").stylua, -- You can also define your own configuration
            function()
                -- Supports conditional formatting
                if util.get_current_buffer_file_name() == "special.lua" then
                    return nil
                end

                -- Full specification of configurations is down below and in Vim help
                -- files
                return {
                    exe = "stylua",
                    args = {
                        "--search-parent-directories",
                        "--stdin-filepath",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },

        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})
