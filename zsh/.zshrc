##### VI MODE #####
bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 == block ]]; then
    echo -ne '\e[1 q'   # block cursor
  else
    echo -ne '\e[5 q'   # beam cursor
  fi
  zle reset-prompt
}
zle -N zle-keymap-select


##### HISTORY #####
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY


##### DIRECTORY NAVIGATION #####
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT


##### COMPLETION (CACHED) #####
autoload -Uz compinit
mkdir -p ~/.cache/zsh
compinit -d ~/.cache/zsh/zcompdump

zmodload zsh/complist
zstyle ':completion:*' menu select
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
_comp_options+=(globdots)

# Vim keys in completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char


##### HISTORY NAVIGATION #####
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' up-history
bindkey '^N' down-history


##### EDITOR #####
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
export VISUAL='nvim'

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line


##### GIT BRANCH SELECTOR #####
branch_selector() {
  local selected_branch new_branch clean_branch

  selected_branch=$(git branch --all | sed 's/^[* ]*//' | \
    fzf --height 60% --reverse --prompt="Select branch> " \
    --preview='git log --oneline --decorate $(echo {} | sed "s/^remotes\///")')

  if [[ -z "$selected_branch" ]]; then
    read "new_branch?No branch selected. Enter new branch name: "
    [[ -z "$new_branch" ]] && return 1
    LBUFFER+="$new_branch"
  else
    clean_branch="${selected_branch#remotes/}"
    LBUFFER+="$clean_branch"
  fi

  zle reset-prompt
}
zle -N branch_selector
bindkey '^B' branch_selector


##### ALIASES #####
alias t="tmux"
alias v="nvim"
alias ls="lsd"
alias l="lsd -l"
alias ..="cd .."
alias top="btop"

# Work
alias rn="npm run dev"
alias fv="npm run cov"
alias bs="npm run build && npm run start"

# Git
alias g="git"
alias gd="g diff"
alias gs="git status"
alias ga="git add . && git commit -m 'fix:' --edit --verbose"
alias gw="g switch -"
alias lg="lazygit"

alias gl='git log --format="%C(auto)%h %C(bold cyan)%an %Creset%s %C(red)(%cr)%Creset"'
alias gld='git log --format="%C(auto)%h %C(bold cyan)%an %Creset%C(red)%ad %Creset%s" --date=format:%Y-%m-%d'
alias glg="git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --date=relative --date-order"

alias dash="gh dash"
alias gapv="git commit --no-verify --amend --no-edit"
alias gpr="gh pr view --web"
alias gpl="gh pr list --author akash-p-mtechzilla"

# Git worktrees + tmux
alias gt="git-tmux-worktree.sh create"
alias gtr="git-tmux-worktree.sh remove"


##### LAZY NVM #####
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

node() { nvm >/dev/null; node "$@"; }
npm()  { nvm >/dev/null; npm "$@"; }
npx()  { nvm >/dev/null; npx "$@"; }


##### PROMPT + TOOLS #####
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


##### YAZI CD INTEGRATION #####
y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}


##### ENV + SECRETS #####
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
[[ -f "$HOME/.zsh_secrets" ]] && source "$HOME/.zsh_secrets"
