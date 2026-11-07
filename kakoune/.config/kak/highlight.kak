# Highlight the word under the cursor
# ───────────────────────────────────
# Based on: https://github.com/mawww/config/blob/d841453cc71f3ab8cbe19ac5036cd86807590617/kakrc#L40-L54
# from https://github.com/JJK96/kakoune-config/blob/master/autoload/highlight.kak
#
# Note: the CurWord face itself is managed by appearance.kak (per-theme),
# since a single hardcoded color can't work on both light and dark.

hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec ,<a-i>w <a-k>\A\w+\z<ret>
        add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
    } catch %{
        add-highlighter -override global/curword group
    } }
}
