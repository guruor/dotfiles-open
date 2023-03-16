local utils = require "utils"


function GetDBUIConnectionName()
    -- dadbod-ui selected environment name
    local env_name
    local db_url = vim.b.db

    if db_url then
        local db_connections = vim.g.dbs
        local decoded_db_url = vim.call('db#url#decode', db_url)

        for _, conn in ipairs(db_connections) do
            local decoded_conn_url = vim.call('db#url#decode', conn.url)
            if decoded_conn_url == decoded_db_url then
                env_name = conn.name
                break
            end
        end
    end

    return env_name or ''
end

function GetRestNvimEnvName()
    -- rest-nvim selected environment name
    local variable_name = "ENV"
    local env_file_path = vim.fn.getcwd() .. "/" .. ".env"
    local env_name = ''

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
    local env_name = ''

    local filetype_env_functions = {
        sql = GetDBUIConnectionName,
        http = GetRestNvimEnvName,
    }

    local func = filetype_env_functions[vim.bo.filetype]
    if (func) then
        env_name = func()
    end

    return env_name
end

-- Lua implementation of PHP scandir function
function Scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls "' .. directory .. '"')

    if pfile ~= nil and pfile ~= '' then
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
    local envdir = sessiondir .. '/envs/'
    local environments = Scandir(envdir)
    vim.ui.select(environments, { prompt = "Choose an environment: " },
        function(chosen_env)
            if chosen_env then
                vim.cmd("!ln -sf " .. envdir .. "/" .. chosen_env .. " .env")
                print("Chosen environment is " .. chosen_env)
            else
                print "Environment not changed"
            end
        end
    )
end

function ToggleTpipeline()
    vim.call('tpipeline#state#toggle')
    local is_active = vim.call('tpipeline#state#is_active')
    if is_active == 0 then
        vim.opt.laststatus = 3
    else
        vim.opt.laststatus = 0
    end
end

function ChooseDBUIConnection()
    local connections_list = vim.call('db_ui#connections_list')
    local connection_names = {}
    local connection_map = {}
    for _, conn in pairs(connections_list) do
        table.insert(connection_names, conn.name)
        connection_map[conn.name] = conn
    end

    vim.ui.select(connection_names, { prompt = "Choose a connection: " },
        function(chosen_conn)
            if chosen_conn then
                print("Chosen connection is " .. chosen_conn)
                local conn = connection_map[chosen_conn]
                vim.b.dbui_db_key_name = conn.name .. "_" .. conn.source
                vim.cmd("DBUIFindBuffer")
                vim.cmd("DBUIFindBuffer")
                vim.cmd("DBUIToggle")
            else
                print "Connection not changed"
            end
        end
    )
end

function ChooseDBUIConnectionOptional()
    print("Choosing db connection")
    if not vim.b.dbui_db_key_name then
        ChooseDBUIConnection()
    else
        print("Already active connection: " .. vim.b.dbui_db_key_name)
    end
end
