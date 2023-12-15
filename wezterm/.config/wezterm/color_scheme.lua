local wezterm = require 'wezterm';

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
local function getColorScheme(color_scheme, default_color_scheme)
  local colors = {}
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
  return colors
end

return {
  getColorScheme = getColorScheme
}