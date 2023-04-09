local wezterm = require 'wezterm';

local color_scheme = "Kanagawa (Gogh)"
-- local color_scheme = "Ayu Mirage"
local colors = wezterm.get_builtin_color_schemes()[color_scheme]

local config = {
  adjust_window_size_when_changing_font_size = false,
  font = wezterm.font_with_fallback({
    -- "Iosevka Nerd Font Mono",
    "JetbrainsMono Nerd Font",
  }),
  window_background_opacity = 0.90,
  window_decorations = "RESIZE",
  macos_window_background_blur = 40,
  hide_tab_bar_if_only_one_tab = false,
  font_size = 17,
  default_prog = { "/usr/bin/arch", "-arm64", "/opt/homebrew/bin/fish" },
  -- color_scheme = "Ayu Mirage",
  -- color_scheme = "Overnight Slumber",
  -- color_scheme = "GitHub Dark",
  color_scheme = color_scheme,
  window_padding = {
    top = 15,
    bottom = 15,
  },
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  colors = {
    tab_bar = {
      background = colors.background,
      active_tab = {
        bg_color = colors.background,
        fg_color = colors.brights[8],
        intensity = "Bold"
      },
      inactive_tab = {
        bg_color = colors.ansi[1],
        fg_color = colors.ansi[8],
      },
      inactive_tab_hover = {
        bg_color = colors.background,
        fg_color = colors.brights[8],
      },
      new_tab = {
        bg_color = colors.ansi[1],
        fg_color = colors.ansi[8],
      },
      new_tab_hover = {
        bg_color = colors.background,
        fg_color = colors.brights[8],
      }
    }
  },
  -- scrollback_lines = 1000000
  command_palette_font_size = 17,
  command_palette_bg_color = colors.ansi[1],
}

return config
