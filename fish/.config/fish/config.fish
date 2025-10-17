set fish_greeting

# Configuration and Secrets
source $__fish_config_dir/secrets.fish
source $__fish_config_dir/claude.fish
source $__fish_config_dir/aliases.fish

set LANG "en_US.UTF-8"
set -x GPG_TTY (tty)
set -x LC_CTYPE en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# Path Configurations
fish_add_path "$HOME/.bin"
fish_add_path "$HOME/.deno/bin"
fish_add_path "$HOME/.spicetify"
fish_add_path "$HOME/.local/bin/hx-utils-bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.bun/bin"
fish_add_path "$HOME/.mix/escripts"
fish_add_path "$HOME/.local/share/bob/nvim-bin"

# Homebrew paths for different architectures
set arc (arch)
if string match -q "arm64" $arc
  fish_add_path "/opt/homebrew/bin/"
  fish_add_path "/opt/homebrew/sbin/"
  fish_add_path "/opt/homebrew/opt/openjdk/bin/"
else
  fish_add_path "/usr/local/bin"
  fish_add_path "/usr/local/sbin"
end

# GNU paths
fish_add_path /opt/homebrew/opt/gnu-getopt/bin
fish_add_path /opt/homebrew/opt/make/libexec/gnubin

fish_add_path "$HOME/Programs/kakoune/src"

# Environment Variables
set -x PIPENV_SHELL_FANCY 1
set -x PIPENV_IGNORE_VIRTUALENVS 1
set -x EDITOR 'k'
set -x KI_EDITOR_THEME "Github Dark"
# claude thing
set -x ENABLE_BACKGROUND_TASKS 1

alias ibrew='arch -x86_64 /usr/local/homebrew/bin/brew'
alias mbrew='arch -arm64e /opt/homebrew/bin/brew'
alias torcurl='curl --socks5-hostname 127.0.0.1:9050'

# Git Aliases
alias g='git' #compdef g=git
alias gst='git status' #compdef _git gst=git-status
alias gd='git diff' #compdef _git gd=git-diff
alias gdc='git diff --cached' #compdef _git gdc=git-diff
alias gpu='git pull' #compdef _git gl=git-pull
alias gpur='git pull --rebase' #compdef _git gup=git-fetch
alias gp='git push' #compdef _git gp=git-push
alias gpf='git push --force-with-lease' #compdef _git gpf=git-push
alias gc='git commit -v' #compdef _git gc=git-commit
alias gcln='git clone' #compdef _git gcln=git-clone
alias gc!='git commit -v --amend' #compdef _git gc!=git-commit
alias gca='git commit -v -a' #compdef _git gc=git-commit
alias gca!='git commit -v -a --amend' #compdef _git gca!=git-commit
alias gcar='git commit -v -a --amend --reuse-message=HEAD' #compdef _git gcar!=git-commit
alias gcmsg='git commit -m' #compdef _git gcmsg=git-commit
alias gco='git checkout' #compdef _git gco=git-checkout
alias gr='git remote' #compdef _git gr=git-remote
alias grv='git remote -v' #compdef _git grv=git-remote
alias grbi='git rebase -i' #compdef _git grbi=git-rebase
alias grbc='git rebase --continue' #compdef _git grbc=git-rebase
alias grba='git rebase --abort' #compdef _git grba=git-rebase
alias gb='git branch' #compdef _git gb=git-branch
alias gba='git branch -a' #compdef _git gba=git-branch
alias gbc-dry='git branch --merged | egrep -v "(^\*|master|dev)"' #compdef _git gbrc-dry='git-branch-cleanup-dryrun'
alias gbc='gbc-dry | xargs git branch -d' #compdef _git gbrc='git-branch-cleanup'
alias gbr='git branch -r' #compdef _git gbr=git-branch-remote
alias gcp='git cherry-pick' #compdef _git gcp=git-cherry-pick
alias gl='git log --oneline --graph'
alias glg='git log --stat --max-count=10' #compdef _git glg=git-log
alias glgg='git log --graph --max-count=10' #compdef _git glgg=git-log
alias glgga='git log --graph --decorate --all' #compdef _git glgga=git-log
alias gss='git status -s' #compdef _git gss=git-status
alias ga='git add' #compdef _git ga=git-add
alias gm='git merge' #compdef _git gm=git-merge
alias grpr-dry='git remote prune origin --dry-run' #compdef _git grpr=git-remote-prune-origin
alias grpr='git remote prune origin' #compdef _git grpr=git-remote-prune-origin
alias gf='git fetch' #compdef _git gf=git-fetch
alias gmt='git mergetool --no-prompt' #compdef _git gm=git-mergetool
alias git-svn-dcommit-push='git svn dcommit; and git push github master:svntrunk' #compdef git-svn-dcommit-push=git
alias ggpull='git pull origin (current_branch)' #compdef ggpull=git
alias ggpur='git pull --rebase origin (current_branch)' #compdef ggpur=git
alias ggpush='git push origin (current_branch)' #compdef ggpush=git
alias ggpnp='git pull origin (current_branch); and git push origin (current_branch)' #compdef ggpnp=gitlias ggpnp='git pull origin (current_branch); and git push origin (current_branch)' #compdef ggpnp=git

# Functions for various purposes
function set_current_docker_host
  set -x DOCKER_HOST (docker context inspect --format '{{.Endpoints.docker.Host}}')
end

function start_iodine
  sudo iodine -r -I1 -T CNAME -m 212 -M 100 -f -P $IODINE_PASSWORD $DNS_TUNNEL
end

function start_dnstt
  dnstt-client -doh https://cloudflare-dns.com/dns-query -pubkey-file $DNSTT_PUB_KEY_PATH $DNS_TUNNEL 127.0.0.1:8000
end

if command -q fnm
  fnm env --use-on-cd | source
end

# if command -q oh-my-posh
#   oh-my-posh init fish --config (mbrew --prefix oh-my-posh)"/themes/uew.omp.json" | source
# end

if command -q starship
  starship init fish | source
  enable_transience
end

if command -q atuin
  # Temporary workaround for deprecated -k flag warning
  # Remove sed once https://github.com/atuinsh/atuin/pull/2902 is released
  atuin init fish | sed "s/-k up/up/g" | source
end

zoxide init fish | source


# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/yukai/.cache/lm-studio/bin

# windsurf
set -gx PATH $PATH /Users/yukai/.codeium/windsurf/bin
