bindkey -v

# Better vim mode
export KEYTIMEOUT=1

# Change cursor shape and redraw prompt for different vi modes.
function zle-keymap-select {
  # This part handles the cursor shape
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q' # block cursor
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q' # beam cursor
  fi
  # This part redraws the prompt, which is useful for showing the current mode
  zle reset-prompt
}
zle -N zle-keymap-select

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS  # Don't record duplicates in history
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blanks
setopt INC_APPEND_HISTORY    # Add commands immediately
setopt EXTENDED_HISTORY      # Add timestamps to history

# Directory navigation
setopt AUTO_CD              # If command is a path, cd into it
setopt AUTO_PUSHD          # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS   # Don't store duplicates in the stack
setopt PUSHD_SILENT        # Do not print directory stack

# Completion
setopt COMPLETE_IN_WORD    # Complete from both ends of a word
setopt ALWAYS_TO_END       # Move cursor to end of word after completion

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' up-history
bindkey '^N' down-history

# Editor Configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
export VISUAL='nvim'

autoload -z edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line


branch_selector() {
  local selected_branch new_branch clean_branch

  selected_branch=$(git branch --all | sed 's/^[* ]*//' | \
    fzf --height 60% --reverse --prompt="Select branch> " \
    --preview='git log --oneline --decorate $(echo {} | sed "s/^remotes\///")')

  if [[ -z "$selected_branch" ]]; then
    read "new_branch?No branch selected. Enter new branch name: "
    if [[ -z "$new_branch" ]]; then
      echo "No branch name provided. Aborting."
      return 1
    else
      # Insert the new branch name at cursor position
      LBUFFER+="$new_branch"
    fi
  else
    # Clean up branch name if it starts with "remotes/"
    clean_branch=$(echo "$selected_branch" | sed 's/^remotes\///')
    # Insert the selected branch name at cursor position
    LBUFFER+="$clean_branch"
  fi

  # Refresh the prompt
  zle reset-prompt
}

zle -N branch_selector
bindkey '^B' branch_selector

# Basic Aliases
alias t="tmux"
alias v='nvim'
alias ls='eza'
alias l='eza -l'
alias ..='cd ..'
alias top="btop"

# Work Related Aliases
alias rn="npm run dev"
alias fv="npm run cov"
alias bs='npm run build && npm run start'

# Git Aliases
alias g="git"
alias gd="g diff"
alias ga="git add . && git commit -m 'fix:' --edit --verbose"
alias gs="git status"
alias gw="g switch -"
alias lg='lazygit'
alias gl='git log --format="%C(auto)%h %C(bold cyan)%an %Creset%s %C(red)(%cr)%Creset"'
alias gld='git log --format="%C(auto)%h %C(bold cyan)%an %Creset%C(red)%ad %Creset%s" --date=format:%Y-%m-%d'
alias glg="git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --date=relative --date-order"
alias dash="gh dash"
alias gapv='git commit --no-verify --amend --no-edit'
alias gpr='gh pr view --web'
alias gpl='gh pr list --author akash-p-mtechzilla'

# Git worktress and tmux
alias gt="git-tmux-worktree.sh create"
alias gtr="git-tmux-worktree.sh remove"


# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Initialize Starship
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

. "$HOME/.local/bin/env"

if [ -f ~/.zsh_secrets ]; then
    . ~/.zsh_secrets
fi

