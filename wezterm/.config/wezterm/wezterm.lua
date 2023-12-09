local wezterm = require 'wezterm';

local default_color_scheme = "Kanagawa (Gogh)"

-- local color_scheme = "Catppuccin Macchiato"
-- local color_scheme = "Ayu Mirage"
local color_scheme = "Kanagawa (Gogh)"
-- local color_scheme = "Flexoki Dark"
-- local color_scheme = "kanagawabones"

-- init colors variable
local colors = {}

-- check if color scheme exists
local function isColorSchemeAvailableAsBultin(c)
  local color_schemes = wezterm.get_builtin_color_schemes()
  for key in pairs(color_schemes) do
    if key == c then
      return true
    end
  end
  return false
end

-- get colors with fallback to default color scheme
if isColorSchemeAvailableAsBultin(color_scheme) then
  colors = wezterm.get_builtin_color_schemes()[color_scheme]
else
  -- try loaded from $HOME/wezterm/config/colors/:name.toml first
  local filepath = os.getenv("HOME") .. "/.config/wezterm/colors/" .. color_scheme .. ".toml"
  local f = io.open(filepath, "r")

  if f ~= nil then
    io.close(f)
    colors = wezterm.color.load_scheme(filepath)
  else
    -- fallback to default color scheme
    colors = wezterm.get_builtin_color_schemes()[default_color_scheme]
  end
end


local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick

-- hover colors
local HOVER_BG = wezterm.color.parse(colors.brights[8]):lighten(0.3)
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

-- wezterm.on(
--   'format-tab-title',
--   function(tab, tabs, panes, config, hover, max_width)
--     local title = tab_title(tab)
--
--     -- ensure that the titles fit in the available space,
--     -- and that we have room for the edges.
--     -- wezterm.log_info("max_width: " .. max_width .. ", " .. "title: " .. title .. ", title length" .. #title)
--     if #title > max_width - 4 then
--       title = wezterm.truncate_right(title, max_width - 3)
--       -- wezterm.log_info("trimmed title: " .. title .. ", title length" .. #title)
--     end
--
--     local edge_background = colors.background
--     local edge_foreground = TAB_BG
--     local background = TAB_BG
--     local foreground = TAB_FG
--
--     if tab.is_active or hover then
--       edge_background = HOVER_FG
--       edge_foreground = HOVER_BG
--       background = edge_foreground
--       foreground = edge_background
--     end
--
--     local tab_bar = {
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_LEFT_ARROW },
--       { Background = { Color = background } },
--       { Foreground = { Color = foreground } },
--       { Text = title },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_RIGHT_ARROW },
--     }
--
--     -- prepend or append padding
--     local tab_id = tab.tab_id
--     local is_first_tab = tab_id == tabs[1].tab_id
--     -- local is_last_tab = #tabs - 1 == tab_id
--
--     local padding_arr = {
--       { Background = { Color = colors.background } },
--       { Foreground = { Color = colors.background } },
--       { Text = " " },
--     }
--
--     -- add left padding for first tab
--     if is_first_tab then
--       table.insert(tab_bar, 1, padding_arr[1])
--       table.insert(tab_bar, 2, padding_arr[2])
--       table.insert(tab_bar, 3, padding_arr[3])
--     end
--
--
--     table.insert(tab_bar, padding_arr[1])
--     table.insert(tab_bar, padding_arr[2])
--     table.insert(tab_bar, padding_arr[3])
--
--     return tab_bar
--   end
-- )

wezterm.on('format-tab-title', function(tab, _, _, _, _)
  -- i do not like how i can basically hide tabs if i zoom in
  local is_zoomed = ''
  if tab.active_pane.is_zoomed then
    is_zoomed = ' ' .. wezterm.nerdfonts.md_arrow_expand_all
  end

  return {
    { Text = ' ' .. tab.tab_index + 1 .. is_zoomed .. ' ' },
  }
end)


-- Modified from https://gist.github.com/gsuuon/5511f0aa10c10c6cbd762e0b3e596b71
local title_color_bg = TAB_BG
local title_color_fg = TAB_FG

local color_off = title_color_bg:lighten(0.4)
local color_on = color_off:lighten(0.4)

wezterm.on("update-status", function(window, pane)
  local bat = ''
  local b = wezterm.battery_info()[1]
  bat = wezterm.format {
    { Foreground = {
      Color =
          b.state_of_charge > 0.2 and color_on or color_off,
    } },
    { Text = '▉' },
    { Foreground = {
      Color =
          b.state_of_charge > 0.4 and color_on or color_off,
    } },
    { Text = '▉' },
    { Foreground = {
      Color =
          b.state_of_charge > 0.6 and color_on or color_off,
    } },
    { Text = '▉' },
    { Foreground = {
      Color =
          b.state_of_charge > 0.8 and color_on or color_off,
    } },
    { Text = '▉' },
    { Background = {
      Color =
          b.state_of_charge > 0.98 and color_on or color_off,
    } },
    { Foreground = {
      Color =
          b.state == "Charging"
          and color_on:lighten(0.3):complement()
          or
          (b.state_of_charge < 0.2 and wezterm.GLOBAL.count % 2 == 0)
          and color_on:lighten(0.1):complement()
          or color_off:darken(0.1)
    } },
    { Text = ' ⚡' },
  }

  local time = wezterm.strftime '%-l:%M %P'

  local bg1 = title_color_bg:lighten(0.1)
  local bg2 = title_color_bg:lighten(0.2)

  local cols = pane:window():active_tab():get_size().cols
  local tabs = pane:window():tabs()
  local tabs_len = #tabs
  local tabs_text_length = 0
  for i, _ in ipairs(tabs) do
    if i > 9 then
      -- two digits tab width
      tabs_text_length = tabs_text_length + 5
    else
      -- one digit tab width
      tabs_text_length = tabs_text_length + 2
    end
  end
  -- new tab button
  tabs_text_length = tabs_text_length + 2

  local workspace_text = window:active_workspace()
  local workspace_text_len = #workspace_text + 2
  local time_text = time .. ' ' .. bat

  local max_title_length = 25
  local title_text = pane:get_title()
  title_text = title_text:sub(1, max_title_length)

  -- calculate for centering title
  -- 9 is for time_text, 7 is for battery info
  local space_left = cols - workspace_text_len - tabs_text_length - 9 - 7
  local space_left_half = math.ceil((space_left - #title_text) / 2) + math.floor(#title_text / 2)

  window:set_right_status(
    wezterm.format {
      { Background = { Color = colors.background } },
      { Foreground = { Color = TAB_FG } },
      { Text = ' ' .. wezterm.pad_right(title_text, space_left_half) .. ' ' },
      { Background = { Color = colors.background } },
      { Foreground = { Color = bg1 } },
      -- rounded left
      { Text = wezterm.nerdfonts.ple_left_half_circle_thick },
      { Background = { Color = title_color_bg:lighten(0.1) } },
      { Foreground = { Color = title_color_fg } },
      { Text = ' ' .. workspace_text .. ' ' },
      { Foreground = { Color = bg1 } },
      { Background = { Color = bg2 } },
      { Text = wezterm.nerdfonts.ple_right_half_circle_thick },
      { Foreground = { Color = title_color_bg:lighten(0.4) } },
      { Foreground = { Color = title_color_fg } },
      { Text = ' ' .. time_text }
    }
  )
end)

local function createFontConfig(fontName)
  local fontConfigs = {
    ["JetbrainsMono Nerd Font"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.08,
      cell_width = 1.0,
      font_size = 15.0,
      harfbuzz_features = {
        -- https://github.com/JetBrains/JetBrainsMono/wiki/OpenType-features

        "calt",
        -- subsitute zero with slashed zero
        "zero",

        "cv06",
        "cv07",
        "cv08",
        "cv14",
        "cv16",

        "cv99",

        -- Closed construction. Change the rhythm to a more lively one.
        -- "ss02",

        -- Shift horizontal stroke in f to match x-height.
        "ss20"
      }
    },
    ["FiraCode Nerd Font Mono"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.1,
      font_size = 15.0,
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
    },
    ["iA Writer Mono V"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.1,
      font_size = 15.0,
    },
    ["CaskaydiaCove Nerd Font"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.25,
      font_size = 15.0,
    },
    ["Monaspace Argon"] = {
      font = wezterm.font_with_fallback({ fontName }),
      line_height = 1.30,
      font_size = 15.0,
      harfbuzz_features = {
        "ss01",
        "ss02",
        "ss03",
        "ss04",
        "ss05",
        "ss06",
        "ss07",
        "ss08",
        "calt",
        "dlig"
      }
    },
    ["GeistMono NF"] = {
      font = wezterm.font_with_fallback({ fontName }),
      font_size = 15.0,
      line_height = 1.3,
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
  scrollback_lines = 1000000,
  command_palette_font_size = 17,
  command_palette_bg_color = colors.ansi[1],

  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.6,
  },

  -- unix_domains = {
  --   { name = "unix" }
  -- }
}

local fontConfig = createFontConfig("JetbrainsMono Nerd Font")
-- local fontConfig = createFontConfig("Monaspace Argon")
-- local fontConfig = createFontConfig("GeistMono NF")
for k, v in pairs(fontConfig) do
  config[k] = v
end

-- multiplexing setup
local mux = wezterm.mux

-- Decide whether cmd represents a default startup invocation
function is_default_startup(cmd)
  if not cmd then
    -- we were started with `wezterm` or `wezterm start` with
    -- no other arguments
    return true
  end
  if cmd.domain == "DefaultDomain" and not cmd.args then
    -- Launched via `wezterm start --cwd something`
    return true
  end
  -- we were launched some other way
  return false
end

-- wezterm.on('gui-startup', function(cmd)
--   if is_default_startup(cmd) then
--     -- for the default startup case, we want to switch to the unix domain instead
--     local unix = mux.get_domain("unix")
--     mux.set_default_domain(unix)
--     -- ensure that it is attached
--     unix:attach()
--   end
-- end)

return config
