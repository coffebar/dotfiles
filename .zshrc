export ZSH="$HOME/.oh-my-zsh"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=blue'

ZSH_THEME="robbyrussell"
ZSH_CLAUDE_SHELL_MODEL="haiku"

plugins=(git sudo pip docker gh zsh-syntax-highlighting zsh-autosuggestions)
if [[ "$XDG_SESSION_OPT" == "cel" ]]; then
    plugins+=(zsh-claude-code-shell)
	alias v=nvim
	alias yy="sudo apt update && sudo apt upgrade; flatpak update"
	alias i="sudo apt install"
	alias dphp='docker compose -f docker-compose.dev.yml exec -it php'
	dtest() {
		docker compose -f docker-compose.dev.yml exec -it php env XDEBUG_MODE=off php bin/phpunit "$@"
	}
else
	plugins+=(zsh_codex)
	source ~/.bash_aliases
fi

source $ZSH/oh-my-zsh.sh

# Aggregate RSS by command name and show apps using >100MB
alias memgt100m='ps -eo comm,rss --no-headers | awk '\''{rss[$1]+=$2} END{for (c in rss) if (rss[c]>102400) printf "%-20s %6.2f GB\n", c, rss[c]/1024/1024}'\'' | sort -k2,2nr'


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

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# zsh-autosuggestions mapping
# ALT+a to accept completion
bindkey '^[a' autosuggest-accept
# ALT+e to accept and execute
bindkey '^[e' autosuggest-execute
