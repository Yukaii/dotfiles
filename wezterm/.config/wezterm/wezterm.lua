local wezterm = require 'wezterm';

return {
  font = wezterm.font_with_fallback({
    -- "Sarasa Term TC Nerd Font",
    -- "Sarasa Term TC",
    "Iosevka Nerd Font Mono",
    -- "Jetbrains Mono",
  }),
  window_background_opacity = 1.0,
  window_decorations = "RESIZE",
  font_size = 18,
  default_prog = {"/usr/bin/arch", "-arm64", "/opt/homebrew/bin/fish"},
  -- color_scheme = "Ayu Mirage",
  -- color_scheme = "Overnight Slumber",
  color_scheme = "GitHub Dark",
  window_padding = {
    left = 15,
    right = 15,
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
}
