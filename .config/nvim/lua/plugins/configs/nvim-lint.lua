-- Module Documentation
-- This module provides helper functions and configurations for managing linters in Neovim using the nvim-lint plugin.
--
-- Key Information:
-- - This table covers redundant linters for similar filetypes.
-- - Available linters: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
-- - Available linters: https://mason-registry.dev/registry/list
--
-- Important Notes:
-- - Ensure that linter names match those in mason-registry.dev for auto-installation to work.
-- - Auto install list supported by mason-nvim-lint: https://github.com/rshkarin/mason-nvim-lint/blob/main/lua/mason-nvim-lint/mapping.lua
-- - Linters with different names in mason can be added to the ignore_install list of mason-nvim-lint.

-- Linters Setup
local linters_by_ft = {
  python = { "vulture" }, -- Vulture detects unused python code
  -- go = { "revive" }, -- revive is not needed when we have golangci_lint
  go = { "golangcilint" },
  -- markdown = { "typos" }, -- typos highlights typing mistakes
  -- env = { "dotenv_linter" }, -- diagnostics.dotenv_linter,
  lua = { "luacheck" },
  docker = { "hadolint" },
  terraform = { "tflint" },
  sql = { "sqlfluff" },
  markdown = { "markdownlint" },
  vim = { "vint" },
}

-- Linters Group Configuration
local linters_by_ft_group = {
  { filetypes = { "sh", "bash", "zsh" }, linters = { "shellcheck" } },
  { filetypes = { "json", "javascript", "typescript" }, linters = { "oxlint", "biomejs" } },
  { filetypes = { "markdown", "vimwiki", "norg" }, linters = { "vale" } },
}

-- Function to append group linters to individual filetype linters
local function append_linters(linters_by_ft_tbl, linters_by_ft_group_tbl)
  for _, group in ipairs(linters_by_ft_group_tbl) do
    if group.filetypes and group.linters then
      for _, filetype in ipairs(group.filetypes) do
        linters_by_ft_tbl[filetype] = linters_by_ft_tbl[filetype] or {}
        for _, linter in ipairs(group.linters) do
          if not vim.tbl_contains(linters_by_ft_tbl[filetype], linter) then
            table.insert(linters_by_ft_tbl[filetype], linter)
          end
        end
      end
    else
      print("Skipping invalid group entry: ", vim.inspect(group))
    end
  end
end

append_linters(linters_by_ft, linters_by_ft_group)

-- Helper functions for active/inactive linter management
local function get_all_linters_by_ft(linters_tbl_key)
  return require("lint")[linters_tbl_key] or {}
end

local function get_linters_for_ft(linters_tbl_key)
  local linters_tbl = get_all_linters_by_ft(linters_tbl_key)
  return linters_tbl[vim.bo.filetype] or {}
end

local function set_linters_for_ft(linters_tbl_key, linters)
  local linters_tbl = get_all_linters_by_ft(linters_tbl_key)
  linters_tbl[vim.bo.filetype] = linters
  require("lint")[linters_tbl_key] = linters_tbl
end

-- Getters
local function get_active_linters_for_ft()
  return get_linters_for_ft "linters_by_ft"
end

local function get_inactive_linters_for_ft()
  return get_linters_for_ft "inactive_linters_by_ft"
end

-- Setters
local function set_active_linters_for_ft(linters)
  return set_linters_for_ft("linters_by_ft", linters)
end

local function set_inactive_linters_for_ft(linters)
  return set_linters_for_ft("inactive_linters_by_ft", linters)
end

-- Enable/Disable Linters
local function enable_linter_for_ft(linter)
  local active_linters = get_active_linters_for_ft()
  if not vim.tbl_contains(active_linters, linter) then
    table.insert(active_linters, linter)
    set_active_linters_for_ft(active_linters)
  end
  local inactive_linters = get_inactive_linters_for_ft()
  for i, v in ipairs(inactive_linters) do
    if v == linter then
      table.remove(inactive_linters, i)
      set_inactive_linters_for_ft(inactive_linters)
      break
    end
  end
end

local function disable_linter_for_ft(linter)
  local inactive_linters = get_inactive_linters_for_ft()
  if not vim.tbl_contains(inactive_linters, linter) then
    table.insert(inactive_linters, linter)
    set_inactive_linters_for_ft(inactive_linters)
  end
  local active_linters = get_active_linters_for_ft()
  for i, v in ipairs(active_linters) do
    if v == linter then
      table.remove(active_linters, i)
      set_active_linters_for_ft(active_linters)
      break
    end
  end
end

local function stop_linters(linter)
  local linters_to_stop = linter
  if #linters_to_stop == 0 then
    linters_to_stop = copy(get_active_linters_for_ft())
  end

  for _, l in ipairs(linters_to_stop) do
    disable_linter_for_ft(l)
  end

  vim.cmd "LintInfo"
  vim.diagnostic.reset(nil, vim.api.nvim_get_current_buf())
  require("lint").try_lint()
end

local function start_linters(linter)
  local linters_to_start = linter
  if #linters_to_start == 0 then
    linters_to_start = copy(get_inactive_linters_for_ft())
  end

  for _, l in ipairs(linters_to_start) do
    enable_linter_for_ft(l)
  end

  vim.cmd "LintInfo"
  require("lint").try_lint()
end

-- Module setup and commands
local M = {}

function M.setup_cmds()
  vim.api.nvim_create_user_command("LintInfo", function()
    local configured_linters = get_active_linters_for_ft()
    local inactive_linters = get_inactive_linters_for_ft()

    if #configured_linters > 0 then
      vim.notify("Configured Linters: " .. table.concat(configured_linters, ", "))
    end

    if #inactive_linters > 0 then
      vim.notify("Inactive Linters: " .. table.concat(inactive_linters, ", "))
    end
  end, {})

  vim.api.nvim_create_user_command("LintStop", function(info)
    stop_linters(info.args)
  end, {
    desc = "Manually stops the active linter(s) on current buffer or session",
    nargs = "*",
    complete = get_active_linters_for_ft,
  })

  vim.api.nvim_create_user_command("LintStart", function(info)
    start_linters(info.args)
  end, {
    desc = "Manually start the linter(s) on current buffer or session",
    nargs = "*",
    complete = get_inactive_linters_for_ft,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("lint", { clear = true }),
    callback = M.config.autocmd_callback,
  })
end

M.config = {
  -- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
  linters_by_ft = linters_by_ft,
  autocmd_callback = function()
    local lint = require "lint"
    lint.try_lint()

    -- Below statements runs cspell for all files
    -- lint.try_lint("cspell")

    -- Conditionally you can override a linter if needed
    -- if your_condition() then
    --  lint.try_lint("eslint")
    -- end
  end,
}

return M
