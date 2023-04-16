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
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
  },
  "romgrk/barbar.nvim",
  "j-hui/fidget.nvim",

  -- Easy search, navigation
  {
    "ibhagwan/fzf-lua",
    dependencies = {

      { "junegunn/fzf", build = "./install --bin" },
    },
  },
  { "folke/which-key.nvim",    keys = { "<leader>", ",", '"', "'", "`" } },
  "majutsushi/tagbar",
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-zoxide",
    },
  },
  { "kevinhwang91/nvim-bqf",  ft = "qf" }, -- For better preview of quickfix buffers
  { "stevearc/dressing.nvim", event = "VeryLazy" }, -- For improved vim.ui interfaces

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
    dependencies = {
      "tommcdo/vim-fubitive",          -- GBrowse bitbucket support
      "shumphrey/fugitive-gitlab.vim", -- Gitlab gitlab support
      "tpope/vim-rhubarb",             -- GBrowse github support
    },
  },
  "lewis6991/gitsigns.nvim",

  -- Syntax, formatting and auto-completion, not needed when using treesitter
  -- "sheerun/vim-polyglot",

  -- Managing and installing LSP servers
  "folke/neodev.nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "simrat39/rust-tools.nvim", ft = "rs" },
      {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        build = ":MasonUpdate",
      },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "glepnir/lspsaga.nvim",     event = "LspAttach" },
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
  "mhartington/formatter.nvim",
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {

      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
      { "windwp/nvim-ts-autotag" },
      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "onsails/lspkind.nvim",
      },
    },
  },

  { "fatih/vim-go",    ft = "go",             build = ":GoUpdateBinaries" },
  "bufbuild/vim-buf",

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {

      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
    },
  },

  -- Task runner
  "stevearc/overseer.nvim",

  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
  },

  -- Additional Functionalities
  "editorconfig/editorconfig-vim",
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  "tpope/vim-repeat",
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
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
  {
    "dhruvasagar/vim-prosession",
    lazy = false,
    dependencies = {
      "tpope/vim-obsession",
    },
  },

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
  { "G0V1NDS/rest.nvim",      branch = "response_body_stored_updated", ft = "http" },
  -- { "rest-nvim/rest.nvim", ft = "http" },

  -- DB query executer
  {
    "kristijanhusak/vim-dadbod-ui",
    ft = "sql",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
  },

  -- File navigator, uses LF file manager to navigate and change working directory
  {
    "ptzz/lf.vim",
    event = "VeryLazy",
    dependencies = {
      "voldikss/vim-floaterm",
    },
  },

  -- VimWiki for note management
  -- vim-polyglot is needed for `plantuml` syntax
  { "vimwiki/vimwiki",        lazy = false,                            dependencies = "sheerun/vim-polyglot" },
  { "AckslD/nvim-FeMaco.lua", cmd = "FeMaco" }, -- For inline code-block edit
  { "mattn/calendar-vim",     cmd = { "CalendarH", "CalendarH" } },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    run = "cd app && yarn install",
  },

  -- Good to have
  "beauwilliams/focus.nvim",
  "ron89/thesaurus_query.vim",
  "christoomey/vim-tmux-navigator", -- Switch windows with C-[h,j,k,l,\], same for tmux panes
  { "NvChad/nvim-colorizer.lua", ft = { "css" } },
  "m4xshen/smartcolumn.nvim",
  -- annotation generator/docstring
  { "danymat/neogen", config = true, event = "VeryLazy" },
  "rcarriga/nvim-notify",

  -- Yet to explorer
  -- "metakirby5/codi.vim",
  -- { "junegunn/vim-easy-align", run = { "EasyAlign" } },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
