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

    return env_name
end

function GetRestNvimEnvName()
    -- rest-nvim selected environment name
    local variable_name = "ENV"
    local env_file_path = vim.fn.getcwd() .. "/" .. ".env"

    -- If there's an env file in the current working dir
    if utils.file_exists(env_file_path) then
        for line in io.lines(env_file_path) do

            local vars = utils.split(line, "=")

            if vars[1] == variable_name then
                return vars[2]
            end
        end
    end
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
