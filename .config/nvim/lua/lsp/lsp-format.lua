local lsp_format = require("lsp-format")

local prettier = {
    tabWidth = 4,
    singleQuote = true,
    trailingComma = "all",
    configPrecedence = "prefer-file",
}

lsp_format.setup {
    typescript = prettier,
    javascript = prettier,
    typescriptreact = prettier,
    javascriptreact = prettier,
    json = prettier,
    css = prettier,
    scss = prettier,
    html = prettier,
    yaml = {
        tabWidth = 2,
        singleQuote = true,
        trailingComma = "all",
        configPrecedence = "prefer-file",
    },
    markdown = prettier,
    sh = {
        tabWidth = 4,
    },
}

lsp_format.disable { args = "" }

return lsp_format
