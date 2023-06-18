# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='nvim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# bindkey -v

  alias ls='lsd'
  alias l='lsd -l'
  alias v='cap & vim'
  alias vim='nvim'
  alias tut='cd /home/akash/development/_toturials/'
  alias Zxc='shutdown now'
  alias top='btop --utf-force'
  alias open='xdg-open'
  # alias cap="xmodmap -e 'clear lock' && xmodmap -e 'keysym Caps_Lock = Escape'"
  alias cap="setxkbmap -option caps:swapescape"
  alias yt="ytfzf -lt"
  alias f="ranger"
  alias cat="batcat"
  alias sudo="sudo"
  alias p="neofetch"
  alias vv='neovide --neovim-bin /usr/local/bin/lvim'
  alias lg='lazygit'
  alias sy='syncthing > /dev/null &'
  alias m='cd /home/akash/Music; f'
  alias ch='npx terminalgpt chat'
  alias ytl='cd /home/akash/code/fun/yt-local && python3 server.py &'
  alias notes='cd /home/akash/notes; v .'
  alias list='cd /home/akash/Documents/my-notes;v .'
  alias vnotes='cd /home/akash/vimtalk; v .'
  alias cpClipboard='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
  alias bt='sudo bluetoothctl power on'

  # fzf
  alias ignoreFiles="find . \( -path '*/node_modules/*' -o -path '*/.git/*' -o -regex '\./\..*' \) -prune -o -type f -print"
  alias fd="ignoreFiles | fzf --reverse --preview='cat {}' --height 70% | cpClipboard"
  alias h='history | cut -c 8- | fzf --reverse --height 70% | cpClipboard && pbpaste'
  alias snd='send $(ignoreFiles | fzf --reverse --preview="cat {}" --height 70%)'

  #apt
  alias install="sudo apt install"
  alias purge="sudo apt purge"
  alias remove="sudo apt remove"
  alias udt="sudo apt update && sudo apt upgrade -y"
  alias nix-udt="nix-env -u '*'"
  
  # work
  alias wk="cd /home/akash/work/dev/hotel-reservation-management-app && rn"
  alias bs='npm run build && npm run start'
  alias rn="npm run dev"

  #git
  alias ga="git add . && git commit -m 'fix:' --edit"
  alias gs="git status"
  alias rbs='git pull origin dev --rebase'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
