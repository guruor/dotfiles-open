local status_ok, dashboard = pcall(require, "dashboard")
if not status_ok then
  return
end

dashboard.setup {
  theme = "hyper", --  theme is doom and hyper default is hyper
  disable_move = false, --  defualt is false disable move keymap for hyper
  shortcut_type = "letter", --  shorcut type 'letter' or 'number'
  change_to_vcs_root = false, -- default is false,for open file in hyper mru. it will change to the root of vcs
  hide = {
    statusline = true, -- hide statusline default is true
    tabline = false, -- hide the tabline
    winbar = false, -- hide winbar
  },
  config = {
    week_header = {
      enable = true,
      append = { "", "  Let's Work  " },
    },
    packages = { enable = true }, -- show how many plugins neovim loaded
    project = {
      enable = true,
      limit = 8,
      action = function(path)
        require("fzf-lua").files { cwd = path }
      end,
    },
    mru = { limit = 8 },
    shortcut = {
      {
        desc = "  Files",
        group = "Label",
        action = "FzfLua files",
        key = "p",
      },
      {
        desc = "  Search",
        group = "Label",
        action = "FzfGrepProjectWithSelection",
        key = "f",
      },
      {
        desc = "  Postman",
        group = "Label",
        action = "cd $REST_NVIM_COLLECTION_PATH | FzfLua files",
        key = "P",
      },
      {
        desc = "  DB",
        group = "Label",
        action = "cd $DADBOD_DB_QUERIES_PATH | FzfLua files",
        key = "d",
      },
      {
        desc = "  Notes",
        group = "Label",
        action = "Neorg journal today",
        key = "n",
      },
      {
        desc = "  Plugins",
        group = "@property",
        action = "Lazy",
        key = "l",
      },
      {
        desc = " ",
        group = "Action",
        action = "quit",
        key = "q",
      },
    },
    footer = { "", "" },
  },
}
