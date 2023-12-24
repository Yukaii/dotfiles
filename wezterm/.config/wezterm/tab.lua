local wezterm = require 'wezterm'

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick

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


local function format_tab_title(tab, _, _, _, _)
  -- i do not like how i can basically hide tabs if i zoom in
  local is_zoomed = ''
  if tab.active_pane.is_zoomed then
    is_zoomed = ' ' .. wezterm.nerdfonts.md_arrow_expand_all
  end

  return {
    { Text = ' ' .. tab.tab_index + 1 .. is_zoomed .. ' ' },
  }
end

local discharging_icons = {
  wezterm.nerdfonts.md_battery_10,
  wezterm.nerdfonts.md_battery_20,
  wezterm.nerdfonts.md_battery_30,
  wezterm.nerdfonts.md_battery_40,
  wezterm.nerdfonts.md_battery_50,
  wezterm.nerdfonts.md_battery_60,
  wezterm.nerdfonts.md_battery_70,
  wezterm.nerdfonts.md_battery_80,
  wezterm.nerdfonts.md_battery_90,
  wezterm.nerdfonts.md_battery,
}

local charging_icons = {
  wezterm.nerdfonts.md_battery_charging_10,
  wezterm.nerdfonts.md_battery_charging_20,
  wezterm.nerdfonts.md_battery_charging_30,
  wezterm.nerdfonts.md_battery_charging_40,
  wezterm.nerdfonts.md_battery_charging_50,
  wezterm.nerdfonts.md_battery_charging_60,
  wezterm.nerdfonts.md_battery_charging_70,
  wezterm.nerdfonts.md_battery_charging_80,
  wezterm.nerdfonts.md_battery_charging_90,
  wezterm.nerdfonts.md_battery_charging_100,
}

local charged_icon = wezterm.nerdfonts.md_battery_heart_variant


local function get_update_status_fn(colors)
  return function(window, pane)
    -- hover colors
    local HOVER_BG = wezterm.color.parse(colors.brights[8]):lighten(0.3)
    local HOVER_FG = wezterm.color.parse(colors.ansi[8]):darken(0.8)
    local TAB_BG = wezterm.color.parse(colors.background):lighten(0.1)
    local TAB_FG = wezterm.color.parse(colors.ansi[8]):lighten(0.5)


    -- Modified from https://gist.github.com/gsuuon/5511f0aa10c10c6cbd762e0b3e596b71
    local title_color_bg = TAB_BG
    local title_color_fg = TAB_FG

    local color_off = title_color_bg:lighten(0.4)
    local color_on = color_off:lighten(0.4)

    local bat = ''
    local b = wezterm.battery_info()[1]

    -- state_of_charge is a float between 0 and 1
    -- convert to 1 to 10
    local battery_index = math.floor(b.state_of_charge * 10 + 0.5)
    local is_charging = b.state == 'Charging'
    local icons = is_charging and charging_icons or discharging_icons
    local icon = icons[battery_index]

    if b.state_of_charge == 1 then
      icon = charged_icon
    end

    -- convert to 2 digits
    local battery_percentage = math.floor(b.state_of_charge * 100 + 0.5)

    bat = wezterm.format {
      { Text = ' ' .. icon .. ' ' },
      { Text = battery_percentage .. '% ' },
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
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = title_color_bg:lighten(0.1) } },
        { Foreground = { Color = title_color_fg } },
        { Text = ' ' .. workspace_text .. ' ' },
        { Foreground = { Color = bg1 } },
        { Background = { Color = bg2 } },
        { Text = SOLID_RIGHT_ARROW },
        { Foreground = { Color = title_color_bg:lighten(0.4) } },
        { Foreground = { Color = title_color_fg } },
        { Text = ' ' .. time_text }
      }
    )
  end
end


return {
  get_update_status_fn = get_update_status_fn,
  format_tab_title = format_tab_title,
}
