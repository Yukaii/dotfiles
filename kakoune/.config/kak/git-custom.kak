declare-user-mode custom-git-actions
map global git g ':enter-user-mode custom-git-actions<ret>' -docstring "custom git actions"

define-command -params ..1 git-pr-diff -docstring %{
  Show pull request diff against the default branch or a specified base branch.
} %{
  evaluate-commands %sh{
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    compare_branch=${1:-$default_branch}
    diffBase=$(git merge-base HEAD $compare_branch)
    echo "git diff $diffBase HEAD"
  }
}

map global git P ':git-pr-diff<ret>' -docstring "PR diff against base branch"

define-command git-file-logs -docstring %{
  Show git commits of current buffer
} %{
  git-log --follow -- %val{bufname}
}

map global custom-git-actions p ':git-pr-diff<ret>' -docstring "PR diff against base branch"
map global custom-git-actions l ':git-file-logs<ret>' -docstring "Git logs against buffer file"

