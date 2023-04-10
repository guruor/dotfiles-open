-- DAP setup for rust, c, cpp
local M = {}

function M.setup(dap)
  dap.configurations.go = {
    -- {
    -- type = "go",
    -- name = "gin_server",
    -- request = "launch",
    -- program = "${workspaceFolder}/cmd/gin_server",
    -- env = {
    -- ENV = "local"
    -- }
    -- },
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    -- works with go.mod packages and sub packages
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
    {
      type = "remote_golang",
      request = "attach",
      name = "Golang: Remote Attach remote_golang",
      connect = {
        host = "0.0.0.0",
        port = 2345,
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

  dap.adapters.remote_golang = function(callback)
    callback {
      type = "server",
      host = "0.0.0.0",
      port = 2345,
    }
  end

  -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = { nil, stdout },
      args = { "dap", "-l", "127.0.0.1:" .. port },
      detached = true,
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print("dlv exited with code", code)
      end
    end)
    assert(handle, "Error running dlv: " .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(function()
      callback { type = "server", host = "127.0.0.1", port = port }
    end, 100)
  end
end

return M
