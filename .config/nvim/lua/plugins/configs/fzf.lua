local utils = require "utils"

require("fzf-lua").setup {
  winopts = {
    border = vim.g.border_style,
    preview = {
      vertical = "down:60%", -- up|down:size
      layout = "vertical", -- horizontal|vertical|flex
    },
  },
  defaults = {
    formatter = "path.filename_first", -- this replaces the Special_fzf_lua function
    keymap = {
      builtin = {
        ["<C-_>"] = "toggle-help", -- Maps Ctrl + ? for help
      },
    },
  },
  path_shorten = true,
  fzf_opts = {
    ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-history",
  },
  -- RIPGREP_CONFIG_PATH is not respected anymore, so better update the rg_opts as needed
  grep = {
    hidden = true, -- enable hidden files
    follow = true, -- follow symlinks
    fzf_opts = {
      ["--ansi"] = "",
      ["--delimiter"] = ":",
      ["--with-nth"] = "2..",
    },
  },
  files = {
    follow = true, -- follow symlinks
  },
}

local function customGrepProject(text, cwd)
  -- As per this issue grep_project and grep should work same except for `search` parameter
  -- But this is not the case, not able to find string `>>>>>` to check for git conflicts
  -- https://github.com/ibhagwan/fzf-lua/issues/231
  -- https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/providers/grep.lua#L421
  -- require("fzf-lua").grep_project({
  -- fzf_cli_args = '--query=' .. text,
  -- })
  local opts = {
    rg_glob = true,
    search = "",
    fzf_cli_args = "--query=" .. text,
  }

  if cwd ~= nil then
    opts["cwd"] = cwd
  end
  require("fzf-lua").grep(opts)
end

local new_cmd = vim.api.nvim_create_user_command

new_cmd("FzfSearchInSpecificDirectory", function()
  vim.ui.input({ prompt = "Directory: ", default = "./", completion = "dir" }, function(dir)
    dir = vim.trim(dir or "")
    if dir == "" then
      return
    end

    vim.ui.input({ prompt = "File pattern: ", default = "*" }, function(pattern)
      pattern = vim.trim(pattern or "")
      if pattern == "" or pattern == "*" then
        pattern = ""
      end

      customGrepProject(pattern, dir)
    end)
  end)
end, { nargs = "*" })

-- lua require'fzf-lua'.grep_project({ fzf_cli_args= '--query='..vim.fn.shellescape(vim.fn.expand('<cword>')) })
-- Triggers telescope grep_string with word under the cursor by default in select mode
new_cmd("FzfGrepProjectWithSelection", function()
  local text = utils.GetVisualorCursorText("", true)
  customGrepProject(text)
end, { nargs = "*" })

new_cmd("FzfBlinesWithSelection", function()
  local text = utils.GetVisualorCursorText("", true)
  require("fzf-lua").blines {
    fzf_cli_args = "--query=" .. vim.fn.shellescape(text),
  }
end, { nargs = "*" })
