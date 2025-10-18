# Alabaster theme for Kakoune
# Based on Tonsky's Alabaster principles: https://tonsky.me/blog/syntax-highlighting/
# Minimal highlighting focused on: strings, constants, comments, and top-level definitions

# Color palette
declare-option str black default
declare-option str dark 'rgb:090618'
declare-option str gray 'rgb:727169'
declare-option str white 'rgb:DCD7BA'
declare-option str blue 'rgb:7E9CD8'
declare-option str green 'rgb:98BB6C'
declare-option str purple 'rgb:957fb8'
declare-option str red 'rgb:C34043'
declare-option str yellow 'rgb:E6C384'
declare-option str psel 'rgba:2D4F6780'
declare-option str ssel 'rgba:22324980'
declare-option str dimgray 'rgb:54546D'

declare-option str background %opt{black}
declare-option str foreground %opt{white}

# Code - Alabaster-inspired minimal highlighting
# Only 4 main colors: green (strings), purple (constants), yellow (comments), blue (definitions)
set-face global value "%opt{purple}"
set-face global type "%opt{white}"
set-face global variable "%opt{white}"
set-face global module "%opt{white}"
set-face global function "%opt{blue}"
set-face global string "%opt{green}"
set-face global keyword "%opt{white}"
set-face global operator "%opt{gray}"
set-face global attribute "%opt{white}"
set-face global bracket "%opt{gray}"
set-face global argument "%opt{white}"
set-face global comma "%opt{gray}"
set-face global constant "%opt{purple}+b"
set-face global class "%opt{blue}"
set-face global comment "%opt{yellow}+b"
set-face global meta "%opt{white}"
set-face global builtin "%opt{white}"

# Markup
set-face global title "%opt{blue}"
set-face global header "%opt{blue}"
set-face global bold "%opt{white}+b"
set-face global italic "%opt{white}+i"
set-face global mono "%opt{green}"
set-face global block "%opt{green}"
set-face global link "%opt{blue}"
set-face global bullet "%opt{gray}"
set-face global list "%opt{white}"

# Builtin faces
set-face global Default "%opt{white},%opt{black}"
set-face global PrimarySelection "default,%opt{psel}"
set-face global SecondarySelection "default,%opt{ssel}"
set-face global PrimaryCursor "%opt{dark},%opt{blue}"
set-face global SecondaryCursor "%opt{dark},%opt{blue}"
set-face global PrimaryCursorEol "%opt{dark},%opt{blue}"
set-face global SecondaryCursorEol "%opt{dark},%opt{blue}"
set-face global LineNumbers "%opt{gray},%opt{black}"
set-face global LineNumberCursor "%opt{blue},%opt{black}+b"
set-face global LineNumbersWrapped "%opt{gray},%opt{black}+i"
set-face global MenuForeground "%opt{dark},%opt{white}+b"
set-face global MenuBackground "%opt{white},%opt{dark}"
set-face global MenuInfo "%opt{dark},%opt{blue}"
set-face global Information "%opt{yellow},%opt{black}"
set-face global Error "%opt{red},%opt{black}"
set-face global StatusLine "%opt{white},%opt{black}"
set-face global StatusLineMode "%opt{blue},%opt{black}"
set-face global StatusLineInfo "%opt{blue},%opt{black}"
set-face global StatusLineValue "%opt{blue},%opt{black}"
set-face global StatusCursor "%opt{white},%opt{blue}"
set-face global Prompt "%opt{green},%opt{black}"
set-face global MatchingChar "%opt{blue},%opt{black}"
set-face global Whitespace "%opt{dimgray},%opt{black}+f"
set-face global WrapMarker Whitespace
set-face global BufferPadding "%opt{black},%opt{black}"

# kak-lsp
set-face global InlayHint "+d@type"
set-face global parameter "%opt{white}"
set-face global enum "%opt{white}"
set-face global InlayDiagnosticError "%opt{red}"
set-face global InlayDiagnosticWarning "%opt{yellow}"
set-face global InlayDiagnosticInfo "%opt{blue}"
set-face global InlayDiagnosticHint "%opt{green}"
set-face global LineFlagError "%opt{red}"
set-face global LineFlagWarning "%opt{yellow}"
set-face global LineFlagInfo "%opt{blue}"
set-face global LineFlagHint "%opt{green}"
set-face global DiagnosticError ",,%opt{red}+c"
set-face global DiagnosticWarning ",,%opt{yellow}+c"
set-face global DiagnosticInfo ",,%opt{blue}+c"
set-face global DiagnosticHint ",,%opt{green}+c"

# Infobox faces
set-face global InfoDefault Information
set-face global InfoBlock block
set-face global InfoBlockQuote block
set-face global InfoBullet bullet
set-face global InfoHeader header
set-face global InfoLink link
set-face global InfoLinkMono header
set-face global InfoMono mono
set-face global InfoRule comment
set-face global InfoDiagnosticError InlayDiagnosticError
set-face global InfoDiagnosticHint InlayDiagnosticHint
set-face global InfoDiagnosticInformation InlayDiagnosticInfo
set-face global InfoDiagnosticWarning InlayDiagnosticWarning

# Tree-sitter - Alabaster-inspired minimal highlighting
set-face global ts_attribute "%opt{white}"
set-face global ts_comment "%opt{yellow}+b"
set-face global ts_conceal "%opt{white}"
set-face global ts_constant "%opt{purple}"
set-face global ts_constant_builtin_boolean "%opt{purple}"
set-face global ts_constant_character "%opt{purple}"
set-face global ts_constant_macro "%opt{purple}"
set-face global ts_constructor "%opt{blue}"
set-face global ts_diff_plus "%opt{green}+b"
set-face global ts_diff_minus "%opt{red}+b"
set-face global ts_diff_delta "%opt{blue}"
set-face global ts_diff_delta_moved "%opt{blue}+i"
set-face global ts_error "%opt{red}"
set-face global ts_function "%opt{blue}"
set-face global ts_function_builtin "%opt{white}"
set-face global ts_function_macro "%opt{white}"
set-face global ts_hint "%opt{blue}+b"
set-face global ts_info "%opt{blue}+b"
set-face global ts_keyword "%opt{white}"
set-face global ts_keyword_conditional "%opt{white}"
set-face global ts_keyword_control_conditional "%opt{white}"
set-face global ts_keyword_control_directive "%opt{white}"
set-face global ts_keyword_control_import "%opt{white}"
set-face global ts_keyword_directive "%opt{white}"
set-face global ts_label "%opt{white}"
set-face global ts_markup_bold "%opt{white}+b"
set-face global ts_markup_heading "%opt{blue}"
set-face global ts_markup_heading_1 "%opt{blue}"
set-face global ts_markup_heading_2 "%opt{blue}"
set-face global ts_markup_heading_3 "%opt{blue}"
set-face global ts_markup_heading_4 "%opt{blue}"
set-face global ts_markup_heading_5 "%opt{blue}"
set-face global ts_markup_heading_6 "%opt{blue}"
set-face global ts_markup_heading_marker "%opt{gray}"
set-face global ts_markup_italic "%opt{white}+i"
set-face global ts_markup_list_checked "%opt{green}"
set-face global ts_markup_list_numbered "%opt{gray}"
set-face global ts_markup_list_unchecked "%opt{gray}"
set-face global ts_markup_list_unnumbered "%opt{gray}"
set-face global ts_markup_link_label "%opt{blue}"
set-face global ts_markup_link_url "%opt{green}+u"
set-face global ts_markup_link_uri "%opt{green}+u"
set-face global ts_markup_link_text "%opt{blue}"
set-face global ts_markup_quote "%opt{yellow}+i"
set-face global ts_markup_raw "%opt{green}"
set-face global ts_markup_strikethrough "%opt{gray}+s"
set-face global ts_namespace "%opt{white}"
set-face global ts_operator "%opt{gray}"
set-face global ts_property "%opt{white}"
set-face global ts_punctuation "%opt{gray}"
set-face global ts_punctuation_special "%opt{gray}"
set-face global ts_special "%opt{white}"
set-face global ts_spell "%opt{red}+u"
set-face global ts_string "%opt{green}"
set-face global ts_string_regex "%opt{green}"
set-face global ts_string_regexp "%opt{green}"
set-face global ts_string_escape "%opt{gray}"
set-face global ts_string_special "%opt{green}"
set-face global ts_string_special_path "%opt{green}+u"
set-face global ts_string_special_symbol "%opt{purple}"
set-face global ts_string_symbol "%opt{purple}"
set-face global ts_tag "%opt{white}"
set-face global ts_tag_error "%opt{red}"
set-face global ts_text "%opt{white}"
set-face global ts_text_title "%opt{blue}"
set-face global ts_type "%opt{white}"
set-face global ts_type_enum_variant "%opt{white}"
set-face global ts_variable "%opt{white}"
set-face global ts_variable_builtin "%opt{white}"
set-face global ts_variable_other_member "%opt{white}"
set-face global ts_variable_parameter "%opt{white}"
set-face global ts_warning "%opt{yellow}+b"

