export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ============================================================================
# ZSH CONFIGURATION
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"

# Speed up repository status for large repos
DISABLE_UNTRACKED_FILES_DIRTY="true"
ENABLE_CORRECTION="true"
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"
ZSH_THEME="robbyrussell"

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
# Better history behavior
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Better completion behavior
setopt COMPLETE_ALIASES
setopt AUTO_CD
setopt CORRECT

plugins=(git fzf z zsh-autosuggestions fast-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# This tells zsh-autosuggestions to use both history AND completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Speed up zsh-autosuggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ============================================================================
# VI MODE CONFIGURATION
# ============================================================================
# Enable vi mode
bindkey -v
# Reduce key delay for faster mode switching
export KEYTIMEOUT=1

CURSOR_BEAM='\e[5 q'
CURSOR_BLOCK='\e[1 q'

# Change cursor based on mode
function zle-keymap-select {
    if [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne $CURSOR_BEAM
    else
        echo -ne $CURSOR_BLOCK
    fi
}
zle -N zle-keymap-select

# Start in insert mode
function zle-line-init { zle -K viins }
zle -N zle-line-init

# ============================================================================
# CUSTOM KEYBINDS
# ============================================================================
# zsh-autosuggestions
# Bind ctrl-y in both vi insert and command modes
bindkey -M viins '^Y' autosuggest-accept
bindkey -M vicmd '^Y' autosuggest-accept

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Enhanced FZF configuration
export FZF_DEFAULT_OPTS="--bind 'ctrl-y:accept' --height 40% --reverse --border --preview-window=right:50%:wrap"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Better less behavior
export LESS="-R -F -X"

export NVIM_DIR="$XDG_CONFIG_HOME/nvim"

# Node version manager
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============================================================================
# ALIASES
# ============================================================================
alias nvimconfig="$EDITOR $NVIM_DIR/init.lua"
alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload="source ~/.zshrc"

# Modern alternatives
command -v exa >/dev/null && alias ls='exa'
command -v bat >/dev/null && alias cat='bat --plain' && alias less='bat'
command -v fd >/dev/null && alias find='fd'
command -v ripgrep >/dev/null && alias grep='rg'

# ============================================================================
# INITIALIZATION
# ============================================================================
# Load local environment if exists
[ -f "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"

# UV completion
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)"

