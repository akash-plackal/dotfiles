# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

# PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:$HOME/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Editors
export EDITOR="nvim"
export VISUAL="nvim"

# -------------------------
# FZF Git Branch Selector (BASH)
# -------------------------
git_branch_select() {
  local branch
  branch=$(git branch --all | sed 's/^[* ]*//' | \
    fzf --height 60% --reverse --prompt="Select branch> " \
    --preview='git log --oneline --decorate $(echo {} | sed "s|^remotes/||")')

  [[ -z "$branch" ]] && return

  branch="${branch#remotes/}"
  READLINE_LINE="${READLINE_LINE}${branch}"
  READLINE_POINT=${#READLINE_LINE}
}

# Ctrl+B binding (bash version)
bind -x '"\C-b":git_branch_select'

# -------------------------
# Aliases
# -------------------------
alias t="tmux"
alias v="nvim"
alias nano="nvim"
alias ls="lsd"
alias l="lsd -l"
alias ..="cd .."
alias top="btop"
alias open="xdg-open"

# Work
alias rn="npm run dev"
alias fv="npm run cov"
alias bs="npm run build && npm run start"

# Git
alias g="git"
alias ga="git add . && git commit -m 'fix:' --edit --verbose"
alias gd="git diff"
alias gs="git status"
alias gw="git switch -"
alias lg="lazygit"

alias gl='git log --format="%C(auto)%h %C(bold cyan)%an %Creset%s %C(red)(%cr)%Creset"'
alias gld='git log --format="%C(auto)%h %C(bold cyan)%an %Creset%C(red)%ad %Creset%s" --date=format:%Y-%m-%d'
alias glg='git log --pretty="%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s" --graph --date=relative --date-order'

alias dash="gh dash"
alias gapv="git commit --no-verify --amend --no-edit"
alias gpr="gh pr view --web"
alias gpl="gh pr list --author akash-p-mtechzilla"

# Worktrees
alias gt="git-tmux-worktree.sh create"
alias gtr="git-tmux-worktree.sh remove"

# -------------------------
# NVM
# -------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# -------------------------
# Starship (BASH)
# -------------------------
 if command -v starship >/dev/null 2>&1; then
   eval "$(starship init bash)"
 fi

# -------------------------
# Zoxide (BASH)
# -------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# Quick zoxide jump
zi() {
  local dir
  dir="$(zoxide query -i)" || return
  cd "$dir"
}

# -------------------------
# Yazi integration
# -------------------------
y() {
  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    cd "$cwd"
  fi
  rm -f "$tmp"
}

# -------------------------
# Secrets
# -------------------------
[ -f ~/.bash_secrets ] && . ~/.bash_secrets

# -------------------------
# Extra bashrc.d
# -------------------------
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    [ -f "$rc" ] && . "$rc"
  done
fi

# opencode
export PATH=/home/akashplackal/.opencode/bin:$PATH
export PATH="$HOME/go/bin:$PATH"
