local M = {
  dap = true,
  strategy = {
    "toggleterm",
    use_shell = true,
    close_on_exit = true,
    open_on_start = true,
  },
  log = {
    {
      type = "file",
      filename = "overseer.log",
      level = vim.log.levels.TRACE,
    },
  },
}

return M
