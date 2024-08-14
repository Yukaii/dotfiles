local wezterm = require 'wezterm';
local color_scheme_module = require 'color_scheme';
local font_config_module = require 'font_config';
local tab_module = require 'tab';

local default_color_scheme = "Kanagawa (Gogh)"
local font_name = "JetbrainsMono Nerd Font"
local color_scheme = "Kanagawa (Gogh)"


-- available color schemes
-- Catppuccin Macchiato (Gogh)
-- Ayu Mirage
-- Flexoki Dark
-- kanagawabones
-- Kanagawa (Gogh)
-- Dimidium

-- available fonts
-- JetbrainsMono Nerd Font
-- Lilex Nerd Font Mono

-- init colors variable
local colors = color_scheme_module.getColorScheme(color_scheme, default_color_scheme)

-- hover colors
local HOVER_BG = wezterm.color.parse(colors.brights[8]):lighten(0.3)
local HOVER_FG = wezterm.color.parse(colors.ansi[8]):darken(0.8)
local TAB_BG = wezterm.color.parse(colors.background):lighten(0.1)
local TAB_FG = wezterm.color.parse(colors.ansi[8]):lighten(0.5)

wezterm.on('format-tab-title', tab_module.format_tab_title)

local update_status_fn = tab_module.get_update_status_fn(colors)
wezterm.on('update-status', update_status_fn)

local config = {
  front_end = "WebGpu",
  adjust_window_size_when_changing_font_size = false,
  -- window_background_opacity = 0.90,
  window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW",
  macos_window_background_blur = 40,
  hide_tab_bar_if_only_one_tab = true,
  tab_max_width = 32,
  font_size = 15,
  default_prog = { "/usr/bin/arch", "-arm64", "/opt/homebrew/bin/fish" },
  -- color_scheme = "Ayu Mirage",
  -- color_scheme = "Overnight Slumber",
  -- color_scheme = "GitHub Dark",
  color_scheme = color_scheme,
  window_padding = {
    top = 10,
    bottom = 10,
  },
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  colors = {
    tab_bar = {
      background = colors.background,
      new_tab = {
        bg_color = TAB_BG,
        fg_color = TAB_FG,
        intensity = "Bold",
      },
      new_tab_hover = {
        bg_color = HOVER_BG,
        fg_color = HOVER_FG,
      }
    }
  },
  scrollback_lines = 50000,
  command_palette_font_size = 17,
  command_palette_bg_color = colors.ansi[1],

  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.6,
  },

  initial_cols = 120,
  initial_rows = 30,

  window_background_opacity = 0.9,
  macos_window_background_blur = 60,
}

font_config_module.loadFontConfig(config, font_name)

return config
