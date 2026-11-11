# appearance.kak — follow macOS system appearance (Light/Dark).
# Dark:  kanagawa colorscheme + kanagawa-wave giallo theme (your current setup).
# Light: dawnfox colorscheme + dawnfox giallo theme (custom, converted from
#        nightfox's dawnfox.tmTheme into ~/.config/giallo.kak/themes).
# Change the four options below to pick different pairs.

declare-option str appearance_dark_colorscheme kanagawa
declare-option str appearance_light_colorscheme dawnfox
declare-option str appearance_dark_giallo kanagawa-wave
declare-option str appearance_light_giallo dawnfox
# Current-line/column (kak-crosshairs) backgrounds per theme.
declare-option str appearance_dark_line 'default,rgb:383838'
declare-option str appearance_light_line 'default,rgb:ebe5df'
# Word-under-cursor (highlight.kak CurWord) background per theme.
declare-option str appearance_dark_word 'default,rgb:4a4a4a'
declare-option str appearance_light_word 'default,rgb:d0d8d8'
declare-option -hidden str appearance_current ""

define-command appearance-apply-giallo -hidden -params 1 %{
  evaluate-commands %sh{
    theme="$1"
    printf '%s\n' "$kak_buflist" | tr ' ' '\n' | while IFS= read -r buf; do
      [ -z "$buf" ] && continue
      esc=$(printf '%s' "$buf" | sed "s/'/''/g")
      printf "evaluate-commands -buffer '%s' %%{ try %%{ giallo-set-theme %s } }\n" "$esc" "$theme"
    done
  }
}

define-command appearance-apply-faces -hidden -docstring 're-apply theme-dependent faces' %{
  evaluate-commands %sh{
    if [ "$kak_opt_appearance_current" = "dark" ]; then
      printf 'set-face global crosshairs_line %s\n' "$kak_opt_appearance_dark_line"
      printf 'set-face global crosshairs_column %s\n' "$kak_opt_appearance_dark_line"
      printf 'set-face global CurWord %s\n' "$kak_opt_appearance_dark_word"
    else
      printf 'set-face global crosshairs_line %s\n' "$kak_opt_appearance_light_line"
      printf 'set-face global crosshairs_column %s\n' "$kak_opt_appearance_light_line"
      printf 'set-face global CurWord %s\n' "$kak_opt_appearance_light_word"
    fi
  }
}

define-command appearance-dark -docstring 'switch to dark theme' %{
  colorscheme %opt{appearance_dark_colorscheme}
  try %{ set-option global giallo_theme %opt{appearance_dark_giallo} }
  set-option global appearance_current dark
  appearance-apply-faces
  try %{ appearance-apply-giallo %opt{appearance_dark_giallo} }
}

define-command appearance-light -docstring 'switch to light theme' %{
  colorscheme %opt{appearance_light_colorscheme}
  try %{ set-option global giallo_theme %opt{appearance_light_giallo} }
  set-option global appearance_current light
  appearance-apply-faces
  try %{ appearance-apply-giallo %opt{appearance_light_giallo} }
}

define-command appearance-auto -docstring 'switch theme from macOS system appearance' %{
  evaluate-commands %sh{
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
      want=dark
    else
      want=light
    fi
    if [ "$kak_opt_appearance_current" != "$want" ]; then
      printf 'appearance-%s\n' "$want"
    fi
  }
}

define-command appearance-toggle -docstring 'toggle light/dark theme' %{
  evaluate-commands %sh{
    if [ "$kak_opt_appearance_current" = "dark" ]; then
      printf 'appearance-light\n'
    else
      printf 'appearance-dark\n'
    fi
  }
}

# Pick theme at startup from current system appearance.
evaluate-commands %sh{
  if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
    printf 'appearance-dark\n'
  else
    printf 'appearance-light\n'
  fi
}

# Re-check when a client regains focus (e.g. after toggling in Control Center).
hook global FocusIn .* %{ appearance-auto }

# The crosshairs plugin hardcodes dark faces when it loads (bundle load runs
# after this file, overwriting the light faces). Re-apply ours afterwards.
hook global User bundle-loaded=crosshair %{ appearance-apply-faces }
