local fav_colorschemes = {
  "gruvbox-material",
  "tokyonight-storm",
  "github_dark",
  "kanagawa",
  "ayu",
  "sonokai",
  "catppuccin-frappe",
  "everforest",
  "iceberg",
  "dracula",
  "seoul256",
}

local colorschemes_set = ListToSet(fav_colorschemes)
local sql_colorscheme = "onedark" -- "PaperColor", "onedark", "palenight"
local go_colorscheme = "github_dark"

require("colorbox").setup {
  filter = {
    function(_, spec)
      return spec.github_stars >= 800
    end,
    function(color, _)
      -- print(color, colorschemes_set[color])
      if colorschemes_set[color] then
        return true
      end
    end,
  },
  background = "dark",
  debug = false,
  -- timing = 'startup',
  -- policy = 'single', -- 'shuffle', 'single', 'in_order', 'reverse_order'
  policy = {
    mapping = {
      org = "github_dark",
      norg = "github_dark",
      markdown = "onedark", -- "nord", "onedark", "github_dark"
      vimwiki = "onedark",
      http = "edge", -- "edge", "gruvbox-baby", "nord", "onedark_vivid", "solarized8_flat"
      sql = sql_colorscheme,
      psql = sql_colorscheme,
      python = "github_dark",
      json = "gruvbox",
      javascript = "gruvbox-baby",
      typescript = "gruvbox-baby",
      go = go_colorscheme,
      gomod = go_colorscheme,
      dashboard = "github_dark",
      yaml = "everforest",
      toml = "everforest",
      lua = "tokyonight-storm",
      nix = "tokyonight-storm",
      vim = "tokyonight-storm",
    },
    empty = "gruvbox-material",
    -- fallback = "gruvbox-material", -- "github_dark"
  },
  timing = "filetype",
  setup = {
    ["projekt0n/github-nvim-theme"] = function()
      require("github-theme").setup()
    end,
    ["folke/tokyonight.nvim"] = function()
      require("tokyonight").setup {
        style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      }
    end,
    ["sainnhe/gruvbox-material"] = function()
      require("plugins.configs.misc").gruvbox_material()
    end,
  },
}
