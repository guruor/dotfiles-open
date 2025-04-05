local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local generalSettingsGroup = augroup("General settings", { clear = true })

-------------------------------------- Toggle relative number -----------------------------------------
local numberToggleGroup = augroup("numbertoggle", { clear = true })
local function shouldSkipNumberToggle()
  if vim.bo.buftype == "terminal" then
    return true
  end

  local excludedFileTypes = { "lazy", "mason", "dashboard" }
  for _, fileType in pairs(excludedFileTypes) do
    if vim.bo.filetype == fileType then
      return true
    end
  end

  return false
end
autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = numberToggleGroup,
  pattern = "*",
  callback = function()
    if not shouldSkipNumberToggle() then
      vim.opt.relativenumber = true
    end
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = numberToggleGroup,
  pattern = "*",
  callback = function()
    if not shouldSkipNumberToggle() then
      vim.opt.relativenumber = false
    end
  end,
})

--------------- Creates directory when saving new file on a path which doesn't exist -------------------
autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
    vim.fn.mkdir(dir, "p")
  end,
})

--------------- Using different indentation pattern for Makefile -----------------
autocmd("FileType", {
  pattern = { "make" },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 0
  end,
  group = generalSettingsGroup,
})

--------------- Enabling spell check for gitcommit -----------------
autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "vimwiki" },
  callback = function()
    vim.opt_local.spell = true
  end,
  group = augroup("Spell settings", { clear = true }),
})

--------------- Vim dadbod dbui, mappings -----------------
autocmd("FileType", {
  pattern = { "dbui" },
  callback = function()
    local mode = "n"
    local opts = { buffer = true }
    vim.keymap.set(mode, "o", "<Plug>(DBUI_SelectLine)", opts)
    vim.keymap.set(mode, "S", "<Plug>(DBUI_SelectLineVsplit)", opts)
    vim.keymap.set(mode, "d", "<Plug>(DBUI_DeleteLine)", opts)
    vim.keymap.set(mode, "R", "<Plug>(DBUI_Redraw)", opts)
    vim.keymap.set(mode, "A", "<Plug>(DBUI_AddConnection)", opts)
    vim.keymap.set(mode, "H", "<Plug>(DBUI_ToggleDetails)", opts)
  end,
  group = generalSettingsGroup,
})

--------------- Vim dadbod dbout, mappings -----------------
autocmd("FileType", {
  pattern = { "dbout" },
  callback = function()
    local mode = "n"
    local opts = { buffer = true }
    vim.keymap.set(mode, "<C-]>", "<Plug>(DBUI_JumpToForeignKey)", opts)
    vim.keymap.set(mode, "vic", "<Plug>(DBUI_YankCellValue)", opts)
    vim.keymap.set(mode, "yh", "<Plug>(DBUI_YankHeader)", opts)
    vim.keymap.set(mode, "<Leader>R", "<Plug>(DBUI_ToggleResultLayout)", opts)
  end,
  group = generalSettingsGroup,
})

--------------- Allowing opening of quick fix entries in new tab -----------------
autocmd("FileType", {
  pattern = { "qf" },
  callback = function()
    local mode = "n"
    local opts = { buffer = true, noremap = true }
    vim.keymap.set(mode, "<Enter>", "<C-W><Enter><C-W>T", opts)
    vim.opt_local.buflisted = false
  end,
  group = generalSettingsGroup,
})

--------------- Opening terminal in insert mode -----------------
autocmd({ "BufWinEnter", "WinEnter" }, {
  pattern = "term://*",
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.cmd.startinsert()
  end,
  group = generalSettingsGroup,
})

--------------- Neomutt -----------------
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "/tmp/neomutt*",
  callback = function()
    vim.cmd ":ZenMode | set bg=light"
  end,
  group = augroup("Neomutt settings", { clear = true }),
})

--------------- Dadbod sql -----------------
-- Auto detect dadbod connection for the file
-- autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = vim.fn.expand "$DB_QUERIES_PATH" .. "/**/*.sql",
--   callback = function()
--     ChooseDBUIConnectionOptional()
--   end,
--   group = augroup("Dadbod sql", { clear = true }),
-- })


--------------- Post save sattings -------------------
-- Runs a script that cleans out tex build files whenever I close out of a .tex file.
local postSaveSettingsGroup = augroup("Post save settings", { clear = true })
autocmd("BufWritePost", {
  pattern = { "bm-files", "bm-dirs" },
  callback = function()
    vim.cmd "!texclear %"
  end,
  group = postSaveSettingsGroup,
})

-- Auto reloads xresources settings
autocmd("BufWritePost", {
  pattern = { "Xresources", "Xdefaults", "xresources", "xdefaults" },
  callback = function()
    vim.cmd "!xrdb %"
  end,
  group = postSaveSettingsGroup,
})

-- Recompile dwmblocks on config edit.
autocmd("BufWritePost", {
  pattern = vim.fn.expand "$HOME" .. "/.local/src/dwmblocks/config.h",
  callback = function()
    vim.cmd "!cd $HOME/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }"
  end,
  group = postSaveSettingsGroup,
})

-- Recompile dwm on config edit.
autocmd("BufWritePost", {
  pattern = vim.fn.expand "$HOME" .. "/.local/src/dwm/config.h",
  callback = function()
    vim.cmd '!cd $HOME/.local/src/dwm/; sudo make install && kill -HUP $(pgrep -u $USER "\bdwm$")'
  end,
  group = postSaveSettingsGroup,
})

-- Restart yabai when yabai config is changed
autocmd("BufWritePost", {
  pattern = vim.fn.expand "$MY_DOTFILES_DIR" .. "/.config/yabai/yabairc",
  callback = function()
    vim.cmd "!yabai --restart-service; killall Dock"
  end,
  group = postSaveSettingsGroup,
})

autocmd("BufWritePost", {
  pattern = vim.fn.expand "$MY_DOTFILES_DIR" .. "/.config/borders/bordersrc",
  callback = function()
    vim.cmd "!brew services restart borders"
  end,
  group = postSaveSettingsGroup,
})

-- Restart skhd when skhd config is changed
autocmd("BufWritePost", {
  pattern = vim.fn.expand "$MY_DOTFILES_DIR" .. "/.config/skhd/skhdrc",
  callback = function()
    vim.cmd "!skhd --restart-service;"
  end,
  group = postSaveSettingsGroup,
})

autocmd("BufWritePost", {
  pattern = vim.fn.expand "$MY_DOTFILES_DIR" .. "/.config/whkdrc",
  callback = function()
    vim.cmd "!Restart-WHKD"
  end,
  group = postSaveSettingsGroup,
})

autocmd("BufWritePost", {
  pattern = vim.fn.expand "$MY_DOTFILES_DIR" .. "/.config/komorebi/komorebi.json",
  callback = function()
    vim.cmd "!StopTiling; StartTiling"
  end,
  group = postSaveSettingsGroup,
})

-- Stops insert mode for terminal window
autocmd("BufLeave", {
  pattern = "term://*",
  callback = function()
    vim.cmd "stopinsert"
  end,
  group = generalSettingsGroup,
})

-- Discard empty noname/scratch buffers
autocmd("BufLeave", {
  pattern = "{}",
  callback = function()
    if vim.bo.filetype == "" and vim.fn.line "$" == 1 and vim.fn.getline(1) == "" then
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "unload"
    end
  end,
  group = generalSettingsGroup,
})

-- Vimwiki default directory based on current working directory
autocmd({ "UIEnter" }, {
  pattern = "*.md",
  callback = function()
    local wikiPath = vim.fn.expand "$VIMWIKI_DIR"
    local currPath = vim.fn.getcwd() .. "/"
    if currPath:find("^" .. wikiPath) ~= nil then
      InitializeVimwikiVars(currPath)
    end
  end,
  group = generalSettingsGroup,
})

-- Vimwiki diary template
autocmd("BufNewFile", {
  pattern = vim.fn.expand "$VIMWIKI_DIR" .. "/**/diary/*.md",
  callback = function()
    vim.cmd 'call append(0,["# Notes for " . split(expand("%:r"),"/")[-1], "", "## TODOs", "", "- [✗] ", "", "## Callouts", "", "- "])'
  end,
  group = generalSettingsGroup,
})


--------------- Auto resize `dbout` buffer and sql buffer for dadbod-ui -----------------
-- autocmd("WinEnter", {
--   pattern = { "*" },
--   callback = function()
--     local fileTypes = { "dbout", "sql" }
--     for _, fileType in pairs(fileTypes) do
--       if vim.bo.filetype == fileType then
--         print("Resizing window") -- Isn't required anymore, we are using focus.nvim for same purpose
--       end
--     end
--   end,
--   group = generalSettingsGroup,
-- })

local easyCloseGroup = augroup("Easy close", { clear = true })
local easyCloseBufTypes = { 'nofile', 'prompt', 'popup' }

autocmd("FileType", {
  pattern = { "dap-float", "vim" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close!<CR>")
  end,
  group = easyCloseGroup,
})

--------------- Disabling focus.nvim -------------------
local focusDisableFiletypes = { 'neo-tree' }
local focusDisableBuftypes = { 'nofile', 'prompt', 'popup' }

local disableFocusAugroup = augroup('FocusDisable', { clear = true })

autocmd('WinEnter', {
    group = disableFocusAugroup,
    callback = function(_)
        if vim.tbl_contains(focusDisableBuftypes, vim.bo.buftype) then
            vim.b.focus_disable = true
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

autocmd('FileType', {
    group = disableFocusAugroup,
    callback = function(_)
        if vim.tbl_contains(focusDisableFiletypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        end
    end,
    desc = 'Disable focus autoresize for FileType',
})
