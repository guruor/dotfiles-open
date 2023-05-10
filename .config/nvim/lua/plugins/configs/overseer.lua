require('overseer').setup({
    dap = true,
    strategy = "toggleterm",
    use_shell = true,
    close_on_exit = false,
    open_on_start = true,
    log = {
        {
            type = "file",
            filename = "overseer.log",
            level = vim.log.levels.TRACE,
        },
    },
})
