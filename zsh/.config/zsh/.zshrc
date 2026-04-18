fpath+=("$ZDOTDIR/pure")

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload -Uz promptinit && promptinit
prompt pure

command -v lsd    > /dev/null && alias ls='lsd'
command -v batcat > /dev/null && alias cat='batcat'
command -v rg     > /dev/null && alias grep='rg'

eval "$(zoxide init zsh)"

fh() {
	print -z $(fc -l 1 | fzf --no-sort --tac | sed -E 's/ *[0-9]*\*? *//')
	zle redisplay
	zle accept-line
}
zle -N fh
bindkey '^R' fh

export FZF_DEFAULT_OPTS="--bind 'ctrl-y:accept' --height 40% --reverse --border --preview-window=right:50%:wrap"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | batcat -p -lman'"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

