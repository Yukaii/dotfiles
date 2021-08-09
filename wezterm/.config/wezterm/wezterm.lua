local wezterm = require 'wezterm';

return {
  font = wezterm.font_with_fallback({
    "Iosevka Nerd Font Mono",
    "Jetbrains Mono",
  }),
  window_background_opacity = 1.0,
  window_decorations = "RESIZE",
  font_size = 18,
  default_prog = {"/usr/bin/arch", "-arm64", "/opt/homebrew/bin/fish"},
  color_scheme = "ayu",
  window_padding = {
    left = 15,
    right = 15,
    top = 15,
    bottom = 15,
  },
  tab_bar_at_bottom = true,
  colors = {    
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      background = "#0f1419",

      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = "#0f1419",
        -- The color of the text for the tab
        fg_color = "#c0c0c0",


        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = "#0f1419",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = "#0f2429",
        fg_color = "#909090",
        italic = false,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = false,

      }
    }  
  }
}