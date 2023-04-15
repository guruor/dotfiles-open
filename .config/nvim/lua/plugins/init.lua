-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

  "nvim-lua/plenary.nvim",

  "rktjmp/lush.nvim",
  "nvim-tree/nvim-web-devicons",
  "rafamadriz/gruvbox",
  "sainnhe/gruvbox-material",
  "nvim-lualine/lualine.nvim",
  { "vimpostor/vim-tpipeline", lazy = false },
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
  },
  "nvim-treesitter/nvim-treesitter-context",
  "romgrk/barbar.nvim",
  "j-hui/fidget.nvim",
  { "junegunn/fzf", build = "./install --bin" },
  "ibhagwan/fzf-lua",
  "jesseleite/vim-agriculture",
  "majutsushi/tagbar",
  "nvim-lua/popup.nvim",
  { "nvim-telescope/telescope.nvim", cmd = "Telescope" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "jvgrootveld/telescope-zoxide",
  "kevinhwang91/nvim-bqf",
  "stevearc/dressing.nvim",

  {
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
      "Gmove",
      "Gdelete",
      "Gremove",
      "Gbrowse",
    },
  },
  "lewis6991/gitsigns.nvim",
  "tommcdo/vim-fubitive",
  "shumphrey/fugitive-gitlab.vim",
  "tpope/vim-rhubarb",

  "sheerun/vim-polyglot",
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  },
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "williamboman/mason-lspconfig.nvim",
  "jay-babu/mason-nvim-dap.nvim",
  "folke/neodev.nvim",
  "neovim/nvim-lspconfig",
  "jose-elias-alvarez/null-ls.nvim",
  "mhartington/formatter.nvim",
  "glepnir/lspsaga.nvim",
  "onsails/lspkind.nvim",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "hrsh7th/nvim-cmp",

  "fatih/vim-go",
  "bufbuild/vim-buf",
  "mfussenegger/nvim-dap",
  "theHamsta/nvim-dap-virtual-text",
  "rcarriga/nvim-dap-ui",
  "jbyuki/one-small-step-for-vimkind",
  "mfussenegger/nvim-dap-python",
  "stevearc/overseer.nvim",
  "alvan/vim-closetag",
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
  },
  "editorconfig/editorconfig-vim",
  "mbbill/undotree",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "numToStr/Comment.nvim",
  "tpope/vim-abolish",
  "ntpeters/vim-better-whitespace",
  "tpope/vim-obsession",
  "dhruvasagar/vim-prosession",
  "junegunn/goyo.vim",
  "junegunn/limelight.vim",
  { "G0V1NDS/rest.nvim", ft = "http" },
  { "tpope/vim-dadbod", ft = "sql" },
  { "kristijanhusak/vim-dadbod-completion", ft = "sql" },
  { "kristijanhusak/vim-dadbod-ui", ft = "sql" },
  "ptzz/lf.vim",
  "voldikss/vim-floaterm",
  "vimwiki/vimwiki",
  "AckslD/nvim-FeMaco.lua",
  "mattn/calendar-vim",
  "iamcco/markdown-preview.nvim",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "beauwilliams/focus.nvim",
  "ron89/thesaurus_query.vim",
  "christoomey/vim-tmux-navigator",
  "NvChad/nvim-colorizer.lua",
  "m4xshen/smartcolumn.nvim",
  "rcarriga/nvim-notify",

  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", ",", '"', "'", "`" },
  },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
