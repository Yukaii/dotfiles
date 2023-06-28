local wezterm = require 'wezterm';

local color_scheme = "Catppuccin Macchiato"
-- local color_scheme = "Ayu Mirage"
-- local color_scheme = "Kanagawa (Gogh)"
-- local color_scheme = "kanagawabones"
local colors = wezterm.get_builtin_color_schemes()[color_scheme]

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick

-- hover colors
local HOVER_BG = wezterm.color.parse(colors.brights[4])
local HOVER_FG = wezterm.color.parse(colors.ansi[8]):darken(0.8)
local TAB_BG = wezterm.color.parse(colors.background):lighten(0.1)
local TAB_FG = wezterm.color.parse(colors.ansi[8]):lighten(0.5)

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    wezterm.log_info("max_width: " .. max_width .. ", " .. "title: " .. title .. ", title length" .. #title)
    if #title > max_width - 4 then
      title = wezterm.truncate_right(title, max_width - 3)
      wezterm.log_info("trimmed title: " .. title .. ", title length" .. #title)
    end

    local edge_background = colors.background
    local edge_foreground = TAB_BG
    local background = TAB_BG
    local foreground = TAB_FG

    if tab.is_active or hover then
      edge_background = HOVER_FG
      edge_foreground = HOVER_BG
      background = edge_foreground
      foreground = edge_background
    end

    local tab_bar = {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }

    -- prepend or append padding
    local tab_id = tab.tab_id
    local is_first_tab = tab_id == tabs[1].tab_id
    -- local is_last_tab = #tabs - 1 == tab_id

    local padding_arr = {
      { Background = { Color = colors.background } },
      { Foreground = { Color = colors.background } },
      { Text = " " },
    }

    -- add left padding for first tab
    if is_first_tab then
      table.insert(tab_bar, 1, padding_arr[1])
      table.insert(tab_bar, 2, padding_arr[2])
      table.insert(tab_bar, 3, padding_arr[3])
    end


    table.insert(tab_bar, padding_arr[1])
    table.insert(tab_bar, padding_arr[2])
    table.insert(tab_bar, padding_arr[3])

    return tab_bar
  end
)

local function createFontConfig(fontName)
  local fontConfigs = {
    ["JetbrainsMono Nerd Font"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.08,
      cell_width = 1.0,
      font_size = 15.0,
    },
    ["FiraCode Nerd Font Mono"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.2,
      font_size = 16.0,
    },
    ["BlexMono Nerd Font"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.2,
      font_size = 16.0,
    },
    ["Iosevka Nerd Font Mono"] = {
      font = wezterm.font_with_fallback({ fontName }),
      -- line_height = 1,
      cell_width = 1.1,
      font_size = 17.0,
    },
    ["iA Writer Mono S"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.1,
      font_size = 15.0,
    }
  }
  return fontConfigs[fontName]
end

local config = {
  front_end = "WebGpu",
  adjust_window_size_when_changing_font_size = false,
  -- window_background_opacity = 0.90,
  window_decorations = "RESIZE",
  macos_window_background_blur = 40,
  hide_tab_bar_if_only_one_tab = false,
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
  -- scrollback_lines = 1000000
  command_palette_font_size = 17,
  command_palette_bg_color = colors.ansi[1],

  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.6,
  }
}

local fontConfig = createFontConfig("JetbrainsMono Nerd Font")
for k, v in pairs(fontConfig) do
  config[k] = v
end

return config
