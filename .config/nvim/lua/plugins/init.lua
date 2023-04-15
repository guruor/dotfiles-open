-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

  -- Common lua utils used by other plugins
  "nvim-lua/plenary.nvim",

  -- Editor look and feel
  "rktjmp/lush.nvim",
  "nvim-tree/nvim-web-devicons",
  -- "npxbr/gruvbox.nvim",
  "rafamadriz/gruvbox",
  "sainnhe/gruvbox-material",
  "nvim-lualine/lualine.nvim",
  { "vimpostor/vim-tpipeline", lazy = false }, -- Merges vim statusline with tmux
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
  },
  "nvim-treesitter/nvim-treesitter-context",
  "romgrk/barbar.nvim",
  "j-hui/fidget.nvim",

  -- Easy search, navigation
  { "junegunn/fzf", build = "./install --bin" },
  "ibhagwan/fzf-lua",
  "jesseleite/vim-agriculture",
  { "folke/which-key.nvim", keys = { "<leader>", ",", '"', "'", "`" } },
  "majutsushi/tagbar",
  "nvim-lua/popup.nvim",
  { "nvim-telescope/telescope.nvim", cmd = "Telescope" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "jvgrootveld/telescope-zoxide",
  "kevinhwang91/nvim-bqf", -- For better preview of quickfix buffers
  "stevearc/dressing.nvim", -- For improved vim.ui interfaces

  -- Git stuff
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
  "tommcdo/vim-fubitive", -- GBrowse bitbucket support
  "shumphrey/fugitive-gitlab.vim", -- Gitlab gitlab support
  "tpope/vim-rhubarb", -- GBrowse github support

  -- Syntax, formatting and auto-completion, not needed when using treesitter
  -- "sheerun/vim-polyglot",

  -- Managing and installing LSP servers
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

  { "fatih/vim-go", build = ":GoUpdateBinaries" },
  "bufbuild/vim-buf",

  -- Debugging
  "mfussenegger/nvim-dap",
  "theHamsta/nvim-dap-virtual-text",
  "rcarriga/nvim-dap-ui",
  "jbyuki/one-small-step-for-vimkind",
  "mfussenegger/nvim-dap-python",

  -- Task runner
  "stevearc/overseer.nvim",

  "alvan/vim-closetag",
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
  },

  -- Additional Functionalities
  "editorconfig/editorconfig-vim",
  "mbbill/undotree",
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "numToStr/Comment.nvim",
  -- easily search for, substitute, and abbreviate multiple variants of a word, replaces vim-abolish
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup {}
    end,
  },
  "ntpeters/vim-better-whitespace",

  -- Session management plugins
  "tpope/vim-obsession",
  "dhruvasagar/vim-prosession",

  -- Better working environment
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    config = function()
      require("twilight").setup()
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup()
    end,
  },

  -- Rest client
  { "G0V1NDS/rest.nvim", branch = "response_body_stored_updated", ft = "http" },
  -- { "rest-nvim/rest.nvim", ft = "http" },

  -- DB query executer
  { "tpope/vim-dadbod", ft = "sql" },
  { "kristijanhusak/vim-dadbod-completion", ft = "sql" },
  { "kristijanhusak/vim-dadbod-ui", ft = "sql" },

  -- File navigator, uses LF file manager to navigate and change working directory
  "ptzz/lf.vim",
  "voldikss/vim-floaterm",

  -- VimWiki for note management
  "vimwiki/vimwiki",
  "AckslD/nvim-FeMaco.lua", -- For inline code-block edit
  "mattn/calendar-vim",
  "iamcco/markdown-preview.nvim",
  { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" },

  -- Snippet
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",

  -- Good to have
  "beauwilliams/focus.nvim",
  "ron89/thesaurus_query.vim",
  "christoomey/vim-tmux-navigator", -- Switch windows with C-[h,j,k,l,\], same for tmux panes
  "NvChad/nvim-colorizer.lua", -- Highlights color code or hash
  "m4xshen/smartcolumn.nvim",
  "rcarriga/nvim-notify",

  -- Yet to explorer
  -- "tpope/vim-sensible",
  -- { "heavenshell/vim-pydocstring", run = "make install" },
  -- "vim-scripts/loremipsum",
  -- "metakirby5/codi.vim",
  -- "dkarter/bullets.vim",
  -- { "junegunn/vim-easy-align", run = { "EasyAlign" } },
  -- Plugings from Luke smith's dotfiles, confirm if still needed
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
