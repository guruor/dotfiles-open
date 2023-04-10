-- DAP setup for rust, c, cpp
local M = {}

function M.setup(dap)
  -- General purpose configs are added by `dap-python` and custom one's are added in .vscode/launch.json
  dap.configurations.rust = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = function()
        local filter = vim.fn.input "Enter args: "
        return { filter }
      end,
      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --
      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --
      -- Otherwise you might get the following error:
      --
      --    Error on launch: Failed to attach to the target process
      --
      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      runInTerminal = false,
    },
  }

  dap.adapters.lldb = {
    type = "executable",
    attach = { pidProperty = "pid", pidSelect = "ask" },
    command = "lldb-vscode",
    name = "lldb",
    env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
  }
end

return M
