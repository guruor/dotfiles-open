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
