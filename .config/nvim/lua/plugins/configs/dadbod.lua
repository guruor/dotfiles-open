local M = {}

function M.setup()
    local db_ui_queries_path = vim.fn.expand("$DADBOD_DB_QUERIES_PATH")
    vim.g.db_ui_save_location = db_ui_queries_path
    vim.g.db_ui_tmp_query_location = db_ui_queries_path .. "/tmp"
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_hide_schemas = { "pg_catalog", "pg_toast_temp.*", "pg_toast" }
    vim.g.db_ui_force_echo_notifications = 1
    vim.g.db_ui_disable_mappings = 1
    vim.g.db_ui_env_variable_url = 'DB_CONNECTION_URL'
    vim.g.db_ui_env_variable_name = 'DB_CONNECTION_NAME'

    -- If password has special symbol substitute them with these symbols
    -- Password must be URL encoded: ab@cd!e => ab%40cd%21e
    -- ! => %21
    -- @ => %40
    -- # => %23
    -- $ => %24

    -- Either use the connection name and url from ENV variables or define a table like below
    -- Env method:
    -- export DBUI_URL=postgresql://postgres:postgres@localhost:5432/default
    -- export DBUI_NAME=pgLocalDefault
    --
    -- Table method:
    -- vim.g.dbs = {
    --     { name = "redisLocalCsk",        url = "redis://localhost:6379/0" },
    --     { name = "redisLocalCskCluster", url = "redis://localhost:30001/0?c" },
    --     -- { name = "redisLocalCskCluster", url = "redis://localhost:6379,localhost:6380,localhost:6381,localhost:6382,localhost:6383,localhost:6384/0?c" },
    --     { name = "pgLocalCsk",           url = "postgresql://postgres:postgres@localhost:5433/cs_india" },
    -- }
    --
    -- To debug a command use below snippet
    -- :echo db#adapter#dispatch("redis://localhost:6379/0", "interactive")
    -- :echo db#adapter#dispatch("redis://localhost:6482/0?c", "interactive")
end

return M
