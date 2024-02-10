local utils = require "utils"

local function load_config(package)
    return function() require('plugins.' .. package) end
end

-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
--
-- This is the load sequence followed by lazy, can be seen by doing `:h lazy.nvim-lazy.nvim-startup-sequence`:
--
-- 1. All the plugins’ `init()` functions are executed
-- 2. All plugins with `lazy=false` are loaded. This includes sourcing `/plugin` and `/ftdetect` files. (`/after` will not be sourced yet)
-- 3. All files from `/plugin` and `/ftdetect` directories in you rtp are sourced (excluding `/after`)
-- 4. All `/after/plugin` files are sourced (this includes `/after` from plugins)

-- List of all default plugins & their definitions
-- vim.g.current_colorscheme = 'gruvbox-material'

local lsp_plugins = {
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = true,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "ray-x/guihua.lua",
    },
    opts = require("plugins.configs.misc").go,
    config = function(_, opts)
      require("go").setup(opts)
    end,
    -- event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
  -- Managing and installing LSP servers
  {
    'folke/neodev.nvim',
    ft = { 'lua', 'vim' },
    config = true
  },
  -- Explore https://github.com/hinell/lsp-timeout.nvim
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "simrat39/rust-tools.nvim", ft = "rs" },
      "jose-elias-alvarez/typescript.nvim",
      {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        build = ":MasonUpdate",
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
      },
      "williamboman/mason-lspconfig.nvim",
      { "jose-elias-alvarez/null-ls.nvim" },
      "b0o/schemastore.nvim",
      -- { dir = "~/Workspace/vim-plugins/null-ls.nvim" },
    },
    config = function()
      require("lsp")
    end,
    event = { 'BufReadPre', 'BufNewFile' },
  },
  -- Debugging
  {
    "mfussenegger/nvim-dap",
    keys = { "<leader>d" },
    cmd = { 'DapUIToggle', 'DapToggleRepl', 'DapToggleBreakpoint' },
    config = function()
      require("dbg")
    end,
    dependencies = {
      "Weissle/persistent-breakpoints.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
    },
  },
  {
    -- Enable virutal text, requires theHamsta/nvim-dap-virtual-text
    "theHamsta/nvim-dap-virtual-text",
    init = function()
      vim.g.dap_virtual_text = true
    end,
    config = true
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    config = function(_, opts)
      require("persistent-breakpoints").setup(opts)
    end,
  },
}

local default_plugins = {

  -- Common lua utils used by other plugins
  "nvim-lua/plenary.nvim",

  -- Editor look and feel
  "nvim-tree/nvim-web-devicons",
  {
    'linrongbin16/colorbox.nvim',
    lazy = false,
    priority = 1000,
    -- required by 'mcchrish/zenbones.nvim'
    dependencies = "rktjmp/lush.nvim",
    build = function() require('colorbox').update() end,
    config = function()
      require("plugins.configs.colorscheme")
      require("plugins.configs.colorboxconf")
      -- Needed this to clear duplicate statusline after colorscheme change
      vim.g.tpipeline_clearstl = 1
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    config = load_config('configs.statusline'),
    -- event = { 'BufReadPre', 'BufNewFile' },
    lazy = false,
    priority = 999,
  },
  {
    "vimpostor/vim-tpipeline",
    -- event = { 'BufReadPre', 'BufNewFile' }, -- Can't lazy load, if lazy loaded duplicate statusline appears
    lazy = false,
    priority = 998,
  }, -- Merges vim statusline with tmux
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo", "TSUpdateSync", "TSUpdate" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    build = ":TSUpdate",
    dependencies = {
      { "LiadOz/nvim-dap-repl-highlights" },
    },
    config = function()
      -- dap-repl must be initialized before treesiter initialisation
      require("nvim-dap-repl-highlights").setup()
      local ts = require("plugins.configs.treesitter")
      require("nvim-treesitter.configs").setup(ts.options)
      ts.additional_setup()
    end,
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = require("plugins.configs.misc").treesitter_context,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  {
    -- Extend and create a/i textobjects, also extends nvim-treesitter/nvim-treesitter-textobjects
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- TODO: register all text objects with which-key similar to LazyVim
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = load_config('configs.bufferline'),
    event = { 'BufReadPre', 'BufNewFile' },
  },

  -- Easy search, navigation
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      { "junegunn/fzf", build = "./install --bin" },
    },
    cmd = { 'FzfLua', 'FzfGrepProjectWithSelection', 'FzfBlinesWithSelection', 'FzfSearchInSpecificDirectory' },
    config = load_config('configs.fzf'),
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-zoxide",
    },
    config = load_config('configs.telescope'),
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" }, -- For better preview of quickfix buffers
  {
    "stevearc/dressing.nvim",
    event = { 'BufReadPre', 'BufNewFile' },
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
  { "sindrets/diffview.nvim",
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

  -- Syntax, formatting and auto-completion, not needed when using treesitter
  -- {"sheerun/vim-polyglot", lazy=false},

  {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = { "<leader>l" },
    opts = require("plugins.configs.conform"),
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    -- Doesn't work with lazy loading
    "andymass/vim-matchup",
    -- keys = { { "%", mode = { "n", "v" } }, { "g%", mode = { "n", "v" } } },
    event = { "BufReadPost" },
    init = function()
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_matchparen_deferred = 1
    end,
    config = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    -- autopairing of (){}[] etc
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>Tp",
        function()
          local Util = require("lazy.core.util")
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            Util.warn("Disabled auto pairs", { title = "Option" })
          else
            Util.info("Enabled auto pairs", { title = "Option" })
          end
        end,
        desc = "Toggle auto pairs",
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = { "rafamadriz/friendly-snippets" },
    config = load_config('configs.snippets'),
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    config = load_config('configs.cmp'),
    dependencies = {
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

  -- Task runner
  {
    "stevearc/overseer.nvim",
    keys = { { "<leader>t" } },
    cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
    config = load_config('configs.overseer'),
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = require("plugins.configs.misc").blankline,
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
    event = { "BufReadPost" },
  },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VeryLazy", -- LazyFile
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  { "mbbill/undotree", cmd = "UndotreeToggle" },

  -- Fast and feature-rich surround actions. For text that includes
  -- surrounding characters like brackets or quotes, this allows you
  -- to select the text inside, change or modify the surrounding characters,
  -- and more.
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = require("plugins.configs.misc").ts_context_commentstring,
    config = function(_, opts)
      require('ts_context_commentstring').setup(opts)
    end,
  },
  {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" } } },
    config = function()
      require("Comment").setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
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
    event = { "BufReadPost" },
    cmd = { "ToggleWhitespace", "DisableWhitespace" }
  },
  {
    "rmagatti/auto-session",
    opts = require("plugins.configs.misc").auto_session,
    init = function(_, opts)
      require("auto-session").setup(opts)
    end,
    lazy = false,
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
    config = load_config('configs.rest'),
  },

  -- DB query executer
  {
    "kristijanhusak/vim-dadbod-ui",
    ft = "sql",
    dependencies = {
      {
        -- "tpope/vim-dadbod",
        "G0V1NDS/vim-dadbod",
        -- dir = "~/Workspace/vim-plugins/vim-dadbod",
        ft = "sql",
      },
      { "kristijanhusak/vim-dadbod-completion", ft = "sql" },
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
    init = function()
      vim.g.lf_netrw = 1
    end,
    cmd = { "Lf" },
    opts = require("plugins.configs.misc").lf,
    dependencies = "toggleterm.nvim",
  },
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "vimwiki", "norg" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function(_, opts)
      require("plugins.configs.headlines").SetHighlights()
      -- Loading it here, as it requires the treesitter queries to be available
      opts = require("plugins.configs.headlines").options
      require("headlines").setup(opts)
    end,
  },
  -- VimWiki for note management
  {
    "vimwiki/vimwiki",
    ft = { "markdown", "vimwiki" },
    keys = { { "<leader>w", mode = { "n", "v" } } },
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
    init = function()
      require "plugins.configs.vimwiki"
    end,
    config = function()
      local currPath = vim.fn.getcwd() .. "/"
      InitializeVimwikiVars(currPath)
    end
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = require("plugins.configs.treesitter").options.autotag.filetypes,
    config = function ()
      require('nvim-ts-autotag').setup()
    end,
  },
  -- Good to have
  { "beauwilliams/focus.nvim", event = "VeryLazy", config = 'require("focus").setup()' },
  {
    "ron89/thesaurus_query.vim",
    keys = { { "<leader>a" } },
    config = load_config('configs.thesaurus'),
  },
  { "christoomey/vim-tmux-navigator", event = "VeryLazy" }, -- Switch windows with C-[h,j,k,l,\], same for tmux panes
  {
    -- Color picker and highlighter plugin for Neovim.
    'uga-rosa/ccc.nvim',
    cmd = { 'CccHighlighterToggle', 'CccConvert', 'CccPick' },
  },
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
  -- {
  --   -- Improve folding
  --   "kevinhwang91/nvim-ufo",
  --   -- event = "VeryLazy",
  --   lazy = false,
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "kevinhwang91/promise-async",
  --   },
  --   init = function()
  --     require("plugins.configs.ufo").SetVimOptions()
  --   end,
  --   opts = require("plugins.configs.ufo").options,
  --   config = function(_, opts)
  --     require("ufo").setup(opts)
  --   end,
  -- },
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
    "folke/flash.nvim", -- leap.nvim alternative
    event = "VeryLazy",
    config = true,
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    'echasnovski/mini.bracketed',
    version = false,
    event = "VeryLazy",
    config = function(_, opts)
      require('mini.bracketed').setup(opts)
    end
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
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
    config = load_config('configs.neotest'),
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = require("plugins.configs.misc").noice,
    config = function(_, opts)
      require("noice").setup(opts)
    end,
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  },
  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", ",", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    event = "VeryLazy",
    cmd = "WhichKey",
    init = load_config("configs.whichkey"), -- Can't lazy load, else dynamic mappings don't load
  },
  -- {
  --   -- https://github.com/3rd/image.nvim/issues/91, works only with luarocks 5.1
  --   "3rd/image.nvim",
  --   ft = { "markdown", "vimwiki", "norg" },
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   opts = require("plugins.configs.image").options,
  --   config = function(_, opts)
  --     require("image").setup(opts)
  --   end
  -- },
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    cmd = { 'Neorg' },
    ft = { 'norg' },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/zen-mode.nvim",
      "max397574/neorg-contexts",
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } }
    },
    opts = require("plugins.configs.neorg").options,
    config = function(_, opts)
      require("neorg").setup(opts)
    end,
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    cmd = { "Hardtime" },
    opts = { max_count = 5 },
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    -- Vim subword movement with w, e, b
    'chrisgrieser/nvim-spider',
    config = load_config('configs.spider'),
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'zbirenbaum/copilot.lua',
    dependencies = { 'zbirenbaum/copilot-cmp' },
    config = load_config('configs.copilot'),
    event = 'InsertEnter',
  },
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead","SudaWrite" },
  },
  {
    'nvimdev/dashboard-nvim',
    config = load_config('configs.dashboard'),
    -- Only load when no arguments
    event = function()
        if vim.fn.argc() == 0 then
            return 'VimEnter'
        end
    end,
    cmd = 'Dashboard',
  },
  {
    "LunarVim/bigfile.nvim",
    event = "VeryLazy",
  }
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

if vim.g.initlsp == 1 then
  table.insert(default_plugins, lsp_plugins)
end

require("lazy").setup(default_plugins, config.lazy_nvim)
