export ZSH="$HOME/.oh-my-zsh"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=blue'

ZSH_THEME="robbyrussell"

plugins=(git sudo pip docker zsh-syntax-highlighting zsh-autosuggestions zsh_codex)

source $ZSH/oh-my-zsh.sh

source ~/.bash_aliases

# zsh-autosuggestions mapping
# ALT+a to accept completion
bindkey '^[a' autosuggest-accept
# ALT+e to accept and execute
bindkey '^[e' autosuggest-execute
# Ctrl+x to use codex openAI based completion
bindkey '^X' create_completion
