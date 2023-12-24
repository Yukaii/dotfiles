local wezterm = require 'wezterm';

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


local function loadFontConfig(config, fontName)
  local fontConfig = createFontConfig(fontName)
  for key, value in pairs(fontConfig) do
    config[key] = value
  end
end


return {
  createFontConfig = createFontConfig,
  loadFontConfig = loadFontConfig
}

