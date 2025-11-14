# Kakship Fill Alignment Investigation

**Date:** 2025-11-14
**Issue:** Starship's `$fill` module doesn't work properly with kakship, resulting in right-aligned content appearing as left-aligned

---

## Problem Summary

When using starship's `$fill` module in kakship configuration, the statusline doesn't properly align content to the left and right sides. Instead, all content appears right-aligned or bunched together without proper spacing.

Expected behavior:
```
137:1 91% 1 sel  starship.toml                      macos-m3[!+?⇡3]  at 11:33 AM
^--- Left side content                  ^--- Right side content ---^
```

Actual behavior:
```
                                        137:1 91% 1 sel  starship.toml  macos-m3[!+?⇡3]  at 11:33 AM
```

---

## Investigation Findings

### 1. How Starship's Fill Works

From starship documentation:
```toml
format = 'AA $fill BB $fill CC'

[fill]
symbol = '-'
style = 'bold green'
```

Produces: `AA -------------------------------------------- BB -------------------------------------------- CC`

The `$fill` module:
- Expands with a repeated symbol to fill available space
- Relies on terminal width information (`--terminal-width` flag)
- Uses ANSI escape codes to create styled spacing
- Works in shells where starship has access to `$COLUMNS`

### 2. Kakship Architecture

Kakship is a wrapper around starship that:
1. Calls `starship prompt` with kakoune-specific environment variables
2. Converts ANSI escape codes to Kakoune face definitions
3. Uses `Mode::Block` conversion for the modeline format

Key code from `kakship/src/main.rs`:
```rust
if args.first().filter(|v| *v == "prompt").is_some() {
    face::print(&stdout, Mode::Block);
}
```

### 3. Testing Results

#### Raw Starship Output (works correctly):
```bash
$ export kak_config=~/.config/kak
$ starship prompt --terminal-width 120
[38;2;191;168;191m~[0m yukai [1;37m  [0m [36mfish[0m [1;30m                                                              [0m  [2;37mFriday[0m
```
The ANSI code `[1;30m` followed by many spaces shows the fill working.

#### Kakship Output (loses fill spacing):
```bash
$ kakship prompt --terminal-width 120
{}%val{cursor_line}:%val{cursor_char_column} {white+d}91%%{}  {{mode_info}} {{context_info}} {white+b} {rgb:BFA8BF+b}starship.toml{black+b} {white+b} {} {rgb:BFA8BF} macos-m3{bright-red}[!+?⇡3]{}  {white+b}at{}
```

Notice:
- Empty face blocks `{}` appear where spacing should be
- No visible sequence of spaces, so the left and right chunks touch
- At this point I assumed the conversion ate the fill, but later testing (below) showed the filler was already tiny when it came out of Starship

#### Control: kakship does keep `$fill` spaces
To be sure the converter wasn't the culprit, I created `tmp/kakship-fill-test/simple-fill.toml` with a trivially short prompt:

```toml
format = "left $fill right"

[fill]
symbol = '.'
style = 'bold green'
```

Running `kak_config=$PWD/tmp/kakship-fill-test/simple kakship prompt --terminal-width 40` prints:

```
{}left {green+b}.............................{} right
```

So the ANSI→Kakoune conversion **does** preserve long runs of fill characters as soon as Starship emits them.

### 4. Why It Doesn't Work

**Updated root cause:** Starship never sees the *actual* width of the left side because most modules output Kakoune placeholders (`%val{…}`, `%sh{…}`, `{{mode_info}}`, …) that are only expanded **after** the prompt is inserted into `modelinefmt`.

1. At Starship render time those placeholders are literal strings 15–25 characters long, so the "left" portion already exhausts the `--terminal-width` budget.
2. When there is no room left, Starship's `$fill` module emits zero or one character (the computation is `max(0, width - left_len - right_len)`).
3. Kakoune then expands the placeholders into short numbers/labels, but the `$fill` had already collapsed, so left/right content meet in the middle.
4. The ANSI→Kak converter does its job; the problem is the stale width information Starship works with.

Supporting evidence (copy of the real config with `$fill` reintroduced in `tmp/kakship-fill-test/bulky/starship.toml`):

```bash
$ STARSHIP_CONFIG=tmp/kakship-fill-test/bulky/starship.toml \
  STARSHIP_CACHE=tmp/starship-cache \
  starship prompt --terminal-width 120
'\x1b[J... \x1b[90m \x1b[0m ...'
```

Only a **single** styled space (`\x1b[90m \x1b[0m`) was produced for the entire fill area.

Feeding the same config to kakship confirms the converter just wraps that lone space:

```bash
$ kak_config=tmp/kakship-fill-test/bulky kakship prompt --terminal-width 120
'... {bright-black} {} ...'
```

So the `$fill` output is tiny **before** Kakoune ever touches it.

**Additional constraint:** Kakoune's `modelinefmt` still lacks right-alignment primitives, so without a correct fill string we cannot fake a right column.

---

## Attempted Fixes

### Attempt 1: Pass Terminal Width
Modified `kakship.kak` to pass `$kak_window_width`:

```kak
kakship prompt --terminal-width $kak_window_width
```

**Result:** Width is passed correctly, but fill still doesn't render because the placeholder-heavy modules already consume that width before Starship runs.

### Attempt 2: Replace Empty Face Blocks
Modified kakship.kak to replace `{}` with spaces:

```bash
prompt_output=$(kakship prompt --terminal-width $kak_window_width)
prompt_output=$(echo "$prompt_output" | sed 's/{}/ /g')
```

**Result:** Doesn't work because:
- Not all `{}` blocks are fill-related (some are valid empty faces)
- The `$fill` module is already spitting out zero/one spaces, so replacing empty faces cannot conjure padding
- The number of real spaces is unknown (they collapsed inside Starship's width math)

### Attempt 3: Manual Padding in Shell Script
Tried to calculate padding manually and insert spaces:

**Result:** Too complex and fragile:
- Need to calculate rendered width (excluding ANSI codes)
- Need to account for multi-byte characters
- Need to update on every window resize
- Kakoune doesn't provide `modelinefmt` with alignment primitives

---

## Workaround: Left-Aligned Statusline

**Current solution:** Remove `$fill` and use a left-aligned statusline.

### Configuration
`~/.config/kak/starship.toml`:
```toml
format = """\
${custom.kakcursor} \
${custom.kakposition} \
${custom.kakmode}\
${custom.kakcontext} \
${custom.kaklsp_modeline}\
${custom.kakfile}\
${custom.kakfiletype} \
$git_branch\
$git_status\
${custom.kaklsp_err}\
${custom.kaklsp_warn}\
${custom.kaklsp_hint}\
${custom.kaklsp_progress} \
${custom.kaktime}\
"""
```

Result:
```
137:1 91% 1 sel  starship.toml  macos-m3[!+?⇡3]  at 11:33 AM
```

All information is visible and readable, just left-aligned instead of split left/right.

---

## Potential Solutions for the Future

### Option 1: Fork Kakship
Create a custom version of kakship that:
1. Detects fill segments in the starship output
2. Calculates the actual rendered width of left/right content
3. Inserts proper Kakoune-formatted spaces to create alignment
4. Uses `$kak_window_width` to dynamically adjust padding

**Complexity:** High
**Maintenance:** Requires keeping fork in sync with upstream

### Option 2: Two-Pass Rendering
Modify kakship to:
1. Call starship twice: once for left content, once for right content
2. Calculate widths and padding in shell
3. Manually construct the modelinefmt with proper spacing

**Complexity:** Medium
**Issue:** Requires splitting starship format into left/right sections

### Option 3: Use Kakoune's Built-in Formatting
Don't use starship at all. Build the statusline purely in Kakoune script:

```kak
set-option window modelinefmt %{
    %val{cursor_line}:%val{cursor_char_column} ...
    %sh{printf '%*s' $((kak_window_width - rendered_width)) ''}
    git info
}
```

**Complexity:** Medium
**Downside:** Lose starship's features and theming

### Option 4: Patch Kakship's ANSI Converter
Modify the `yew-ansi` crate or kakship's conversion logic to:
1. Detect continuous sequences of styled spaces
2. Preserve them as literal spaces in the output
3. Mark them with a special face that Kakoune can expand

**Complexity:** High
**Requires:** Rust knowledge and understanding of the ANSI parsing library

---

## Relevant Files

- `/Users/yukai/.config/kak/kakship.kak` - Custom kakship loader
- `/Users/yukai/.config/kak/starship.toml` - Kakoune-specific starship config
- `/Users/yukai/.config/starship.toml` - Shell starship config (for reference)
- `/Users/yukai/.config/kak/kakrc` - Kakoune configuration

---

## References

- [Starship Fill Module Documentation](https://starship.rs/config/#fill)
- [Kakship GitHub](https://github.com/eburghar/kakship)
- [Kakoune modelinefmt Documentation](https://github.com/mawww/kakoune/blob/master/doc/pages/options.asciidoc#information-ui)

---

## Conclusion

The `$fill` module cannot work as long as Starship must reason about raw Kakoune placeholders: it computes the fill length *before* `%val` / `%sh` / `{{mode_info}}` are expanded, so it almost always believes there is no horizontal space left. Kakship's converter faithfully preserves whatever Starship outputs, which in practice is just zero–one spaces, hence the apparent failure.

**Recommendation:** stick with the left-aligned statusline until we either:
- rewrite the modules so they render real text (using `$kak_*` env vars or helper scripts) *before* Starship runs, or
- teach kakship to perform its own padding after Kakoune evaluates the placeholders.

Either option is invasive; the first one loses access to things like `{{mode_info}}`, and the second essentially requires a kakship fork with custom width accounting.
