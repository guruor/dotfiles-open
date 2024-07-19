local wezterm = require("wezterm")
local config = wezterm.config_builder()
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- PoserShell for windows
  config.default_prog = { "pwsh.exe", "-NoLogo" }
else
  config.default_prog = { "/bin/zsh", "--login" }
end

-- Use wsl if present
local wsl_domains = wezterm.default_wsl_domains()
for _, dom in ipairs(wsl_domains) do
  -- Using default shell as zsh for linux
  dom.default_prog = { "zsh" }
  -- Set specific linux version as default
  config.default_domain = dom.name
end

-- color_scheme = "Gruvbox dark, soft (base16)",
config.color_scheme = "GitHub Dark"

config.font_size = 14
-- config.font = wezterm.font("Fisa Code")
config.font = wezterm.font({ family = "JetBrainsMono Nerd Font" })
config.bold_brightens_ansi_colors = true
config.font_rules = {
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font({ family = "Maple Mono", weight = "Bold", style = "Italic" }),
    },
    {
        italic = true,
        intensity = "Half",
        font = wezterm.font({ family = "Maple Mono", weight = "DemiBold", style = "Italic" }),
    },
    {
        italic = true,
        intensity = "Normal",
        font = wezterm.font({ family = "Maple Mono", style = "Italic" }),
    },
}

config.hide_tab_bar_if_only_one_tab = true
-- NONE | TITLE | RESIZE
config.window_decorations = "RESIZE"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.automatically_reload_config = false

return config
