-- https://alpha2phi.medium.com/neovim-dap-enhanced-ebc730ff498b
-- :DIInstall jsnode_dbg
-- :DIInstall go_delve_dbg
local dap = require 'dap'
local dap_install = require("dap-install")

dap_install.config("python", {})
-- Golang
dap_install.config("go", {})
dap_install.config("go_delve", {})
-- Rust, C, C++
dap_install.config("codelldb", {})
dap_install.config("ccppr_vsc", {})
dap_install.config("ccppr_lldb", {})
-- Javascript
dap_install.config("jsnode", {})
dap_install.config("chrome", {})
-- Lua
dap_install.config("lua", {})

local mapper = function(mode, key, result)
    vim.api.nvim_set_keymap(mode, key, result, {noremap = true, silent = true})
end

dap.adapters.lldb = {
    type = 'executable',
    attach = {pidProperty = "pid", pidSelect = "ask"},
    command = 'lldb-vscode',
    name = "lldb",
    env = {LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"}
}

dap.adapters.python = {type = 'executable', command = '/usr/bin/python', args = {'-m', 'debugpy.adapter'}}

dap.adapters.nlua = function(callback, config)
    callback({type = 'server', host = config.host, port = config.port})
end

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = {nil, stdout},
      args = {"dap", "-l", "127.0.0.1:" .. port},
      detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print('dlv exited with code', code)
      end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require('dap.repl').append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(
      function()
        callback({type = "server", host = "127.0.0.1", port = port})
      end,
      100)
  end

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        program = "${file}",
        pythonPath = function(_)
            return '/usr/bin/python'
        end
    }
}

dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
        host = function()
            local value = vim.fn.input('Host [127.0.0.1]: ')
            if value ~= "" then return value end
            return '127.0.0.1'
        end,
        port = function()
            local val = tonumber(vim.fn.input('Port: '))
            assert(val, "Please provide a port number")
            return val
        end
    }
}

dap.configurations.rust = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
            local filter = vim.fn.input('Enter args: ')
            return {filter}
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
        runInTerminal = false
    }
}


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
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    }
}

dap.configurations.c = dap.configurations.rust
dap.configurations.cpp = dap.configurations.rust

-- Enable virutal text, requires theHamsta/nvim-dap-virutal-text
vim.g.dap_virtual_text = true
-- Enable virutal text, requires rcarriga/nvim-dap-ui
require("dapui").setup()
-- Enable virutal text, requires mfussenegger/nvim-dap-python, overide it with .vscode/launch.json
require('dap-python').setup("~/.pyenv/versions/debugpy/bin/python")

vim.cmd('command! -nargs=0 DapBreakpoints :lua require\'dap\'.list_breakpoints()')
