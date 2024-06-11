return {
  {
    -- Git stuff
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Gedit",
      "Gsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "Glgrep",
      "GMove",
      "GDelete",
      "GRemove",
    },
  },
  {
    "linrongbin16/gitlinker.nvim",
    -- dir = "~/Workspace/vim-plugins/gitlinker.nvim", -- Fork for ruifm/gitlinker.nvim
    cmd = { "GitLink" },
    config = true,
  }, -- Similar functionality like fugitive GBrowse
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    opts = function()
      return require("plugins.configs.gitsigns").options
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
    opts = require("plugins.configs.misc").diffview,
    config = function(_, opts)
      require("diffview").setup(opts)
    end,
  },
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    opts = require("plugins.configs.misc").neogit,
  },
}
