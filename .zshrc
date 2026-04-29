export ZSH="$HOME/.oh-my-zsh"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=blue'

ZSH_THEME="robbyrussell"

plugins=(git sudo pip docker zsh-syntax-highlighting zsh-autosuggestions zsh_codex gh)

source $ZSH/oh-my-zsh.sh

source ~/.bash_aliases

# foot integration:
# allows to copy last command output to clipboard with Alt+l
function precmd {
    if ! builtin zle; then
        print -n "\e]133;D\e\\"
    fi
}
function preexec {
    print -n "\e]133;C\e\\"
}

eval "$(zoxide init zsh)"

# zsh-autosuggestions mapping
# ALT+a to accept completion
bindkey '^[a' autosuggest-accept
# ALT+e to accept and execute
bindkey '^[e' autosuggest-execute
