local utils = require "utils"

-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

  -- Common lua utils used by other plugins
  "nvim-lua/plenary.nvim",

  -- Editor look and feel
  "rktjmp/lush.nvim",
  "nvim-tree/nvim-web-devicons",
  -- "npxbr/gruvbox.nvim",
  -- "rafamadriz/gruvbox",
  {
    "sainnhe/gruvbox-material",
    init = function()
      require("plugins.configs.misc").gruvbox_material()
      return require "plugins.configs.colorscheme"
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    init = function()
      require "plugins.configs.statusline"
    end,
  },
  { "vimpostor/vim-tpipeline", lazy = false }, -- Merges vim statusline with tmux
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    dependencies = {
      { "LiadOz/nvim-dap-repl-highlights", lazy = false },
    },
    opts = require("plugins.configs.treesitter").options,
    config = function(_, opts)
      require("nvim-dap-repl-highlights").setup()
      require("nvim-treesitter.configs").setup(opts)
      require("plugins.configs.treesitter").additional_setup()
    end,
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "romgrk/barbar.nvim",
    init = function()
      require "plugins.configs.barbar"
    end,
  },
  "j-hui/fidget.nvim",

  -- Easy search, navigation
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      { "junegunn/fzf", build = "./install --bin" },
    },
    init = function()
      require "plugins.configs.fzf"
    end,
  },
  {
    "folke/which-key.nvim",
    keys = { "<leader>", ",", '"', "'", "`" },
    config = function()
      require "plugins.configs.whichkey"
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-zoxide",
    },
    config = function()
      require "plugins.configs.telescope"
    end,
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" }, -- For better preview of quickfix buffers
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = require("plugins.configs.misc").dressing,
  }, -- For improved vim.ui interfaces

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
      "tommcdo/vim-fubitive", -- GBrowse bitbucket support
      "shumphrey/fugitive-gitlab.vim", -- Gitlab gitlab support
      "tpope/vim-rhubarb", -- GBrowse github support
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require "plugins.configs.gitsigns"
    end,
  },

  -- Syntax, formatting and auto-completion, not needed when using treesitter
  -- {"sheerun/vim-polyglot", lazy=false},

  -- Managing and installing LSP servers
  "folke/neodev.nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "simrat39/rust-tools.nvim", ft = "rs" },
      "jose-elias-alvarez/typescript.nvim",
      { "fatih/vim-go", ft = "go", build = ":GoUpdateBinaries" },
      {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        build = ":MasonUpdate",
      },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "glepnir/lspsaga.nvim", event = "LspAttach" },
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
  "mhartington/formatter.nvim",
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require "plugins.configs.cmp"
    end,
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        config = function()
          require "plugins.configs.snippets"
        end,
      },
      {
        -- autopairing of (){}[] etc
        "windwp/nvim-autopairs",
        opts = { fast_wrap = {}, disable_filetype = { "TelescopePrompt", "vim" } },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
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
        "f3fora/cmp-spell",
        "rcarriga/cmp-dap",
        "hrsh7th/cmp-calc",
      },
    },
  },
  "bufbuild/vim-buf",

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    keys = { "<leader>d" },
    dependencies = {
      "Weissle/persistent-breakpoints.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
    },
  },

  -- Task runner
  {
    "stevearc/overseer.nvim",
    keys = { { "<leader>t" } },
    config = function()
      require "plugins.configs.overseer"
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = require("plugins.configs.misc").blankline,
    config = function(_, opts)
      require("indent_blankline").setup(opts)
    end,
  },

  { "mbbill/undotree", cmd = "UndotreeToggle" },
  "tpope/vim-repeat",
  {
    "kylechui/nvim-surround",
    keys = { { "gys" }, { "gcs" }, { "gds" } },
    opts = require("plugins.configs.misc").surround,
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end,
  },
  {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" } } },
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", dependencies = "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("plugins.configs.misc").comment()
    end,
  },
  -- easily search for, substitute, and abbreviate multiple variants of a word, replaces vim-abolish
  {
    "johmsalas/text-case.nvim",
    config = 'require("textcase").setup()',
    keys = { { "ga", mode = { "n", "v" } } },
  },
  {
    "ntpeters/vim-better-whitespace",
    init = function()
      require("plugins.configs.misc").whitespace()
    end,
  },
  {
    "rmagatti/auto-session",
    opts = require("plugins.configs.misc").auto_session,
    init = function(_, opts)
      require("auto-session").setup(opts)
    end,
  },

  -- Better working environment
  { "folke/twilight.nvim", cmd = "Twilight", config = 'require("twilight").setup()' },
  { "folke/zen-mode.nvim", cmd = "ZenMode", config = 'require("zen-mode").setup()' },

  -- Rest client
  {
    -- "rest-nvim/rest.nvim",
    "G0V1NDS/rest.nvim",
    -- branch = "response_body_stored_updated",
    branch = "response_body_stored",
    ft = "http",
    config = function()
      require "plugins.configs.rest"
    end,
  },

  -- DB query executer
  {
    "kristijanhusak/vim-dadbod-ui",
    ft = "sql",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
      if utils.file_exists(vim.fn.expand "$HOME" .. "/.config/nvim/lua/Private/plugins/configs/dadbod.lua") then
        require("Private/plugins/configs/dadbod").setup()
      end
    end,
  },

  -- File navigator, uses LF file manager to navigate and change working directory
  {
    "lmburns/lf.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.configs.misc").lf()
    end,
    dependencies = { "plenary.nvim", "toggleterm.nvim" },
  },
  -- VimWiki for note management
  {
    "vimwiki/vimwiki",
    ft = { "markdown", "vimwiki" },
    -- lazy = false,
    dependencies = {
      { "mattn/calendar-vim", cmd = { "CalendarH", "CalendarH" } },
      { "AckslD/nvim-FeMaco.lua", cmd = "FeMaco", config = 'require("femaco").setup()' }, -- For inline code-block edit
      {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown", "vimwiki" },
        -- lazy = false,
        build = 'function() vim.fn["mkdp#util#install"]() end',
      },
      -- {
      --   -- vim-polyglot is needed for `plantuml` syntax
      --   "sheerun/vim-polyglot",
      --   event = "VeryLazy",
      -- },
    },
    config = function()
      require "plugins.configs.vimwiki"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = false,
  },
  -- Good to have
  { "beauwilliams/focus.nvim", event = "VeryLazy", config = 'require("focus").setup()' },
  {
    "ron89/thesaurus_query.vim",
    event = "VeryLazy",
    config = function()
      require "plugins.configs.thesaurus"
    end,
  },
  { "christoomey/vim-tmux-navigator", event="VeryLazy" }, -- Switch windows with C-[h,j,k,l,\], same for tmux panes
  { "NvChad/nvim-colorizer.lua", cmd = { "ColorizerToggle" }, config = 'require("colorizer").setup()' },
  {
    "m4xshen/smartcolumn.nvim",
    event = "VeryLazy",
    opts = require("plugins.configs.misc").smartcolumn,
    config = function(_, opts)
      require("smartcolumn").setup(opts)
    end,
  },
  -- annotation generator/docstring
  { "danymat/neogen", config = true, event = "VeryLazy" },
  { "rcarriga/nvim-notify", event = "VeryLazy" },
  {
    -- Improve folding
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      require "plugins.configs.ufo"
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = require("plugins.configs.misc").chatgpt,
    config = function(_, opts)
      require("chatgpt").setup(opts)
    end,
  },
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    dependencies = {},
    config = function()
      require("leap").set_default_keymaps()
    end,
  },
  -- Testing
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    event = "VeryLazy",
    keys = {
      { "<c-q>", [[:ToggleTerm<cr>]], silent = true },
      { "<c-q>", [[<c-\><c-n>:ToggleTerm<cr>]], mode = "t", silent = true },
    },
  },
  {
    "nvim-neotest/neotest",
    keys = { { "<leader>rt" } },
    dependencies = {
      "vim-test/vim-test",
      "nvim-neotest/neotest-vim-test",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "KaiSpencer/neotest-vitest",
      "haydenmeade/neotest-jest",
      "nvim-neotest/neotest-plenary",
    },
    config = function()
      require "plugins.configs.neotest"
    end,
  },
  -- Yet to explorer
  -- "metakirby5/codi.vim",
  -- { "junegunn/vim-easy-align", run = { "EasyAlign" } },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
