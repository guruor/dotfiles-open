require('overseer').setup({
    dap = true,
    log = {
        {
            type = "file",
            filename = "overseer.log",
            level = vim.log.levels.TRACE,
        },
    },
})
