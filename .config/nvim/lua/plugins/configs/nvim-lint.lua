local linters_by_ft = {
  -- python = { "ruff" }, -- Already covered by pyright lsp
  python = { "vulture" }, -- Vulture detects unused python code
  -- go = { "revive" }, -- revive is not needed when we have golangci_lint
  go = { "golangcilint" },
  -- markdown = { "typos" }, -- typos highlights typing mistakes
  -- env = { "dotenv_linter" }, -- diagnostics.dotenv_linter,
}

-- This table covers redundant linters for similar filetypes
local linters_by_ft_group = {
  { filetypes = { "sh", "bash", "zsh" }, linters = { "shellcheck" } },
  { filetypes = { "json", "javascript", "typescript" }, linters = { "oxlint", "biomejs" } },
  { filetypes = { "markdown", "vimwiki", "norg" }, linters = { "vale" } },
}

function vim.tbl_contains(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

local function append_linters(linters_by_ft, linters_by_ft_group)
  for _, group in ipairs(linters_by_ft_group) do
    if group.filetypes and group.linters then
      for _, filetype in ipairs(group.filetypes) do
        if not linters_by_ft[filetype] then
          linters_by_ft[filetype] = {}
        end
        for _, linter in ipairs(group.linters) do
          if not vim.tbl_contains(linters_by_ft[filetype], linter) then
            table.insert(linters_by_ft[filetype], linter)
          end
        end
      end
    else
      print("Skipping invalid group entry: ", vim.inspect(group))
    end
  end
end

append_linters(linters_by_ft, linters_by_ft_group)

return {
  -- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
  linters_by_ft = linters_by_ft,
  autocmd_callback = function()
    local lint = require "lint"
    lint.try_lint()

    -- Below statements runs cspell for all files
    -- lint.try_lint("cspell")

    -- Conditionally you can override a linter if needed
    -- if your_condition() then
    --   lint.try_lint("eslint")
    -- end
  end,
}
