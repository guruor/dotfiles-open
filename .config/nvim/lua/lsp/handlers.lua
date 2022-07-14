vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        update_in_insert = false,
        signs = {
            severity_limit = 'Warning',
        },
    })(...)
    pcall(vim.diagnostic.setloclist, { open = false })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = vim.g.floating_window_border_dark,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = vim.g.floating_window_border_dark,
})
