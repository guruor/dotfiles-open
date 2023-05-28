local utils = require "utils"

vim.g.hidden_all = 0
-- Function for toggling the bottom statusbar:
function ToggleHiddenAll()
  if vim.g.hidden_all == 0 then
    vim.g.hidden_all = 1
    vim.opt.laststatus = 0
    vim.opt.showmode = false
    vim.opt.showcmd = false
    vim.opt.ruler = false
  else
    vim.g.hidden_all = 0
    vim.opt.laststatus = 3
    vim.opt.showmode = true
    vim.opt.showcmd = true
    vim.opt.ruler = true
  end
end

-- Function for toggling vim background
function ToggleBackground(bg)
  if bg ~= nil then
    vim.opt.background = bg
  else
    if vim.o.background == "light" then
      P(vim.opt.background)
      vim.o.background = "dark"
    else
      vim.opt.background = "light"
    end
  end
end

function GetDBUIConnectionName()
  -- dadbod-ui selected environment name
  local env_name
  local db_url = vim.b.db

  if db_url then
    local db_connections = vim.g.dbs
    local decoded_db_url = vim.call("db#url#decode", db_url)

    for _, conn in ipairs(db_connections) do
      local decoded_conn_url = vim.call("db#url#decode", conn.url)
      if decoded_conn_url == decoded_db_url then
        env_name = conn.name
        break
      end
    end
  end

  return env_name or ""
end

function GetRestNvimEnvName()
  -- rest-nvim selected environment name
  local variable_name = "ENV"
  local env_file_path = vim.fn.getcwd() .. "/" .. ".env"
  local env_name = ""

  -- If there's an env file in the current working dir
  if utils.file_exists(env_file_path) then
    for line in io.lines(env_file_path) do
      local vars = utils.split(line, "=")

      if vars[1] == variable_name then
        env_name = vars[2]
        break
      end
    end
  end

  return env_name
end

function GetEnvironmentName()
  local env_name = ""

  local filetype_env_functions = {
    sql = GetDBUIConnectionName,
    http = GetRestNvimEnvName,
  }

  local func = filetype_env_functions[vim.bo.filetype]
  if func then
    env_name = func()
  end

  return env_name
end

-- Lua implementation of PHP scandir function
function Scandir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls "' .. directory .. '"')

  if pfile ~= nil and pfile ~= "" then
    for filename in pfile:lines() do
      i = i + 1
      t[i] = filename
    end
    pfile:close()
  end
  return t
end

function SelectRestNvimEnvironment()
  local sessiondir = vim.fn.getcwd()
  local envdir = sessiondir .. "/envs/"
  local environments = Scandir(envdir)
  vim.ui.select(environments, { prompt = "Choose an environment: " }, function(chosen_env)
    if chosen_env then
      vim.cmd("!ln -sf " .. envdir .. "/" .. chosen_env .. " .env")
      print("Chosen environment is " .. chosen_env)
    else
      print "Environment not changed"
    end
  end)
end

function RestNvimRunCurrentFile()
  local fname = vim.fn.expand "%"
  vim.ui.input({ prompt = "HTTP File: ", default = fname, completion = "file" }, function(file)
    file = vim.trim(file or "")
    if file == "" then
      return
    end

    -- local collection_dir=os.getenv("REST_NVIM_COLLECTION_PATH")
    -- local collection_dir="collections"
    -- local file_rel_path=collection_dir.."/"..file
    local opts = { keep_going = true, verbose = true }
    -- local opts = {}
    local file_rel_path = file
    print("Running http file: " .. file_rel_path)
    require("rest-nvim").run_file(file_rel_path, opts)
    -- require("rest-nvim").run_file(file)

    -- lua require("rest-nvim").run_file("collections/auth.http")
    -- lua require("rest-nvim").run_file("tests/basic_get.http")
  end)
end

function ToggleTpipeline()
  vim.call "tpipeline#state#toggle"
  local is_active = vim.call "tpipeline#state#is_active"
  if is_active == 0 then
    vim.opt.laststatus = 3
  else
    vim.opt.laststatus = 0
  end
end

function GetDBUIConnectionNames()
  local connections_list = vim.call "db_ui#connections_list"
  local connection_names = {}
  for _, conn in pairs(connections_list) do
    table.insert(connection_names, conn.name)
  end

  return connection_names
end

function GetDBUIConnectiondMap()
  local connections_list = vim.call "db_ui#connections_list"
  local connection_map = {}
  for _, conn in pairs(connections_list) do
    connection_map[conn.name] = conn
  end

  return connection_map
end

function RefreshDBUIConnection(connectionName)
  local connection_map = GetDBUIConnectiondMap()
  local conn = connection_map[connectionName]
  vim.b.dbui_db_key_name = conn.name .. "_" .. conn.source
  vim.cmd "DBUIFindBuffer"
  vim.cmd "DBUIFindBuffer"
  vim.cmd "DBUIToggle"
end

function ChooseDBUIConnection()
  local connection_names = GetDBUIConnectionNames()

  vim.ui.select(connection_names, { prompt = "Choose a connection: " }, function(chosen_conn)
    if chosen_conn then
      print("Chosen connection is " .. chosen_conn)
      RefreshDBUIConnection(chosen_conn)
    else
      print "Connection not changed"
    end
  end)
end

function ChooseDBUIConnectionOptional()
  print "Choosing db connection..."
  local cwd = vim.fn.getcwd()
  if not vim.b.dbui_db_key_name then
    local connectionDir = cwd:match "^.+/(.+)$"
    if connectionDir then
      RefreshDBUIConnection(connectionDir)
    else
      ChooseDBUIConnection()
    end
  else
    print("Already active connection: " .. vim.b.dbui_db_key_name)
  end
end

-- boolify strings!
local toBool = {
  ["1"] = true,
  ["0"] = false,
}

-- Note: `foldcolumn` is not a boolean. You can set other values.
-- I only want to toggle between these two values though.
function ToggleFoldcolumn()
  if toBool[vim.api.nvim_win_get_option(0, "foldcolumn")] then
    vim.opt.foldcolumn = "0"
  else
    vim.opt.foldcolumn = "1"
  end

  require "notify"(
    "foldcolumn is set to " .. vim.api.nvim_win_get_option(0, "foldcolumn"),
    "info",
    { title = "Window Option Toggled:" }
  )
end

function CloseAllFloatingWindows()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then  -- is_floating_window?
      vim.api.nvim_win_close(win, false)  -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
end

-- https://github.com/rmagatti/auto-session/issues/224
function RemoveFugitiveTab()
  local tabpages = vim.api.nvim_list_tabpages()
  for _, tabpage in ipairs(tabpages) do
    local windows = vim.api.nvim_tabpage_list_wins(tabpage)
    for _, window in ipairs(windows) do
      local buffer = vim.api.nvim_win_get_buf(window)
      local file_name = vim.api.nvim_buf_get_name(buffer)
      if string.find(file_name, "fugitive:") then
        vim.api.nvim_win_close(window, true)
        break
      end
    end
  end
end

-- Add window navigation using vim-tmux-navigator for Terminal windows
function AddTerminalNavigation()
  -- This could cause issue with terminal programs like `fzf`,
  -- you are safe as long as you are using <c-n> and <c-p> to navigate through options
  -- https://github.com/christoomey/vim-tmux-navigator/pull/172#issuecomment-612219227
  if vim.bo.filetype == 'toggleterm' then
    vim.api.nvim_buf_set_keymap(0, "t", "<c-h>", "<c-\\><c-n>:TmuxNavigateLeft<cr>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "t", "<c-j>", "<c-\\><c-n>:TmuxNavigateDown<cr>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "t", "<c-k>", "<c-\\><c-n>:TmuxNavigateUp<cr>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "t", "<c-l>", "<c-\\><c-n>:TmuxNavigateRight<cr>", { noremap = true, silent = true })
  end
end


local function getVimwikiPathTable(vimwikiList)
  local pathTable = {}

  for _, obj in ipairs(vimwikiList) do
    if not pathTable[obj.path] then
      pathTable[obj.path] = {}
    end
    table.insert(pathTable[obj.path], obj)
  end

  return pathTable
end

function InitializeVimwikiVars(currPath)
  -- InitializeVimwikiVars prioritizes current path in available vimwiki list
  local updatedVimwikiList = {}
  local vimwikiPathTable = getVimwikiPathTable(vim.g.vimwiki_list)

  -- If current path is one of vimwiki directory then change the wiki variables accordingly
  if vimwikiPathTable[currPath] ~= nil then
    -- Inserting the highest priority wikis first
    local currentPathWikis = vimwikiPathTable[currPath]
    vimwikiPathTable[currPath] = {}
    for _, obj in ipairs(currentPathWikis) do
      table.insert(updatedVimwikiList, obj)
    end

    -- Inserting low priority wiki at the end
    for _, objects in pairs(vimwikiPathTable) do
      for _, obj in ipairs(objects) do
        table.insert(updatedVimwikiList, obj)
      end
    end

    vim.g.vimwiki_list = updatedVimwikiList
    -- This reloads vimwiki variables
    vim.api.nvim_call_function("vimwiki#vars#init", {})
  end
end
