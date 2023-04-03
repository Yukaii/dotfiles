local wezterm = require 'wezterm';

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
  color_scheme = "Kanagawa (Gogh)",
  window_padding = {
    top = 15,
    bottom = 15,
  },
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  colors = {
    tab_bar = {
      background = "#0f1419",
      active_tab = {
        bg_color = "#0f1419",
        fg_color = "#c0c0c0",
        italic = false,
        strikethrough = false,
      },
      inactive_tab = {
        bg_color = "#0f1419",
        fg_color = "#808080",
      },
      inactive_tab_hover = {
        bg_color = "#051d4d",
        fg_color = "#909090",
        italic = false,
      },
      new_tab = {
        bg_color = "#0f1419",
        fg_color = "#8b949e",
      },
      new_tab_hover = {
        bg_color = "#032f62",
        fg_color = "#c9d1d9",
        italic = false,
      }
    }
  },
  -- scrollback_lines = 1000000
  command_palette_font_size = 17,
  command_palette_bg_color = "#1F1F28",
}

return config
