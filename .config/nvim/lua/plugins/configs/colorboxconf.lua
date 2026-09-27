-- colorbox.nvim config, aligned with the current (post-#278) plugin design.
--
-- Why this differs from the previous version:
--   * #278 "fix(source)!: migrate to manual maintained data source" replaced the crawled dataset
--     (db.json, where each repo carried `color_names` = every colourscheme file, flavours included)
--     with hand-maintained meta/*.lua that lists ONE canonical name per repo. Loading a name that
--     is not in that dataset returns silently (colorbox/loader.lua:25-28), so the filetype policy
--     re-applied it on every BufEnter/WinEnter/FocusGained/TermEnter forever and the buffer never
--     changed colour.  => map canonical names; pick a flavour in `setup` (below) or by hand.
--   * the dataset no longer carries `github_stars` (stars are a collection-time criterion now, see
--     the plugin README), so a stars filter fails for every colour and `filter.lua` counts a
--     failing filter as false, which emptied the plugin's available-colour list.
--     => filter on colour names only.
--   * the filetype policy applies with no guard (policy/filetype.lua:36), while the builtin policy
--     checks `color ~= vim.g.colors_name` first (policy/builtin.lua:69). One apply costs ~500ms
--     (packadd + repo setup + :colorscheme; a raw :colorscheme is ~76ms).  => guard at the bottom.
--   * transient UI buffers (picker, file manager, terminals, launcher panes) open mid-keystroke and
--     are not in the mapping, so every open applied `fallback` and re-applied the language colour
--     on the way back.  => those buffers are now left untouched.
--
-- Nothing here patches the plugin: the only runtime addition is the loader guard at the bottom.

local fav_colorschemes = {
  "gruvbox-material",
  "tokyonight", -- canonical name; the `setup` below pins style = "storm"
  "github_dark",
  "kanagawa",
  "ayu",
  "sonokai",
  "catppuccin", -- canonical name; was "catppuccin-frappe" (a flavour, not in the dataset)
  "everforest",
  "iceberg",
  "dracula",
  "seoul256",
}

local colorschemes_set = ListToSet(fav_colorschemes)
local sql_colorscheme = "onedark" -- "PaperColor", "onedark", "palenight"
local go_colorscheme = "github_dark"
local shell_colorscheme = "github_dark"
local js_colorscheme = "github_dark"

require("colorbox").setup {
  filter = function(color, _)
    -- Must return a real boolean: returning nil (implicit) makes colorbox log
    -- "[colorbox] failed to invoke function filter, please check your config!"
    return colorschemes_set[color] == true
  end,
  background = "dark",
  debug = false,
  -- timing = 'startup',
  -- policy = 'single', -- 'shuffle', 'single', 'in_order', 'reverse_order'
  policy = {
    mapping = {
      org = "github_dark",
      norg = "github_dark",
      markdown = "github_dark", -- "nord", "onedark", "github_dark"
      vimwiki = "github_dark",
      http = "edge", -- "edge", "gruvbox-baby", "nord", "onedark_vivid", "solarized8_flat"
      sql = sql_colorscheme,
      psql = sql_colorscheme,
      python = "github_dark",
      json = js_colorscheme,
      javascript = js_colorscheme,
      typescript = js_colorscheme,
      javascriptreact = js_colorscheme,
      typescriptreact = js_colorscheme,
      go = go_colorscheme,
      gomod = go_colorscheme,
      rust = "github_dark",
      dashboard = "github_dark",
      yaml = "everforest",
      terraform = "everforest",
      toml = "everforest",
      lua = "tokyonight", -- resolves to g:colors_name = "tokyonight-storm"
      nix = "tokyonight",
      vim = "tokyonight",
      sh = shell_colorscheme,
      bash = shell_colorscheme,
      zsh = shell_colorscheme,
    },
    empty = "github_dark",
    fallback = "github_dark",
  },
  timing = "filetype",
  setup = {
    ["projekt0n/github-nvim-theme"] = function()
      require("github-theme").setup()
    end,
    ["folke/tokyonight.nvim"] = function()
      -- the flavour: loading canonical "tokyonight" lands on g:colors_name = tokyonight-storm
      require("tokyonight").setup {
        style = "storm", -- `storm`, `moon`, `night`, `day`
      }
    end,
    ["sainnhe/gruvbox-material"] = function()
      require("plugins.configs.misc").gruvbox_material()
    end,
  },
}

-- Transient UI buffers (picker, file manager, terminals, launcher panes) open *mid-keystroke* and
-- their file type is not in the mapping, so every open would apply `fallback` and re-apply the
-- language colour on the way back. Leave them alone: keep whatever the language buffer set.
local ui_filetypes = ListToSet({ "fzf", "yazi", "toggleterm", "lazy", "NvimTree", "neo-tree", "TelescopePrompt" })

-- Same guarantee the plugin's builtin policy already gives, applied to the filetype policy: skip the
-- switch when the requested colour is already in effect. A canonical name can resolve to a flavour
-- ("tokyonight" -> "tokyonight-storm"), so treat "<target>-<flavour>" as active too, otherwise the
-- apply repeats on every window/buffer event.
local colorbox_loader = require("colorbox.loader")
local colorbox_load = colorbox_loader.load

colorbox_loader.load = function(color, ...)
  local current = vim.g.colors_name or ""
  if vim.bo.buftype ~= "" or ui_filetypes[vim.bo.filetype] then
    return
  end
  if current == color or current:match("^" .. vim.pesc(color) .. "[-_]") then
    return
  end
  return colorbox_load(color, ...)
end
