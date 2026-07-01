return {
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide `brew install tree-sitter tree-sitter-cli`
    opts = require("plugins.configs.tree-sitter-manager"),
    config = function(_, opts)
      require("tree-sitter-manager").setup(opts)

      vim.treesitter.language.register("markdown", "vimwiki")
      vim.treesitter.language.register("markdown", "chatgpt")
      vim.treesitter.language.register("powershell", "ps1")
      vim.treesitter.language.register("nu", "nu")
    end,
    cmd = { "TSManager", "TSInstall", "TSUninstall", "TSUpdate" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
    branch = "main", -- Ensures you are on the updated branch
    event = "VeryLazy",
    config = function()
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- ==========================================
      -- A. MOVEMENT (Your ported jumping maps)
      -- ==========================================

      -- Jump Forward to Start (]f, ]c)
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })

      -- Jump Forward to End (]F, ]C)
      vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
      vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end, { desc = "Next class end" })

      -- Jump Backward to Start ([f, [c)
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function start" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class start" })

      -- Jump Backward to End ([F, [C)
      vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev function end" })
      vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end, { desc = "Prev class end" })


      -- ==========================================
      -- B. BONUS HELPFUL JUMPS (Often overlooked)
      -- ==========================================

      -- Quick jumps to conditional blocks/loops (matching your 'o' object in mini.ai)
      vim.keymap.set({ "n", "x", "o" }, "]o", function() move.goto_next_start("@loop.outer", "textobjects") end, { desc = "Next loop" })
      vim.keymap.set({ "n", "x", "o" }, "[o", function() move.goto_previous_start("@loop.outer", "textobjects") end, { desc = "Prev loop" })


      -- ==========================================
      -- C. SWAPPING (Extremely helpful tree-sitter feature)
      -- ==========================================
      -- Allows you to swap parameters/arguments within function calls quickly.
      -- Pressing '<leader>sa' swaps the current parameter under your cursor with the next one.

      vim.keymap.set("n", "<leader>sa", function() swap.swap_with_next("@parameter.inner", "textobjects") end, { desc = "Swap param with next" })
      vim.keymap.set("n", "<leader>sA", function() swap.swap_with_previous("@parameter.inner", "textobjects") end, { desc = "Swap param with prev" })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "romus204/tree-sitter-manager.nvim",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "css",
      "lua",
      "xml",
      "php",
      "markdown",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
