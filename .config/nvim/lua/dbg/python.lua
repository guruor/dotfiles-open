local M = {}

function M.setup(dap)
  -- General purpose configs are added by `dap-python` and custom one's are added in .vscode/launch.json
  dap.configurations.python = {
    {
      type = "remote_python",
      request = "attach",
      name = "Python: Remote Attach remote_python",
      connect = {
        host = "0.0.0.0",
        port = 5678,
      },
      logToFile = true,
      cwd = vim.fn.getcwd(),
      pathMappings = {
        {
          localRoot = "${workspaceFolder}",
          remoteRoot = "/app",
        },
      },
    },
  }

  -- dap.adapters.python = {type = 'executable', command = '/usr/bin/python', args = {'-m', 'debugpy.adapter'}}
  dap.adapters.remote_python = function(callback)
    callback {
      type = "server",
      host = "0.0.0.0",
      port = 5678,
    }
  end
end

return M
