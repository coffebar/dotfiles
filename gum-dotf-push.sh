#!/usr/bin/env /bin/zsh
function dotf {
	git --git-dir=$HOME/dotfiles --work-tree=$HOME "$@"
}
function push {
	# commit all dotfiles to github repo
	COMMIT_MESSAGE=$(gum input --placeholder 'Commit message') && dotf commit -a -m "$COMMIT_MESSAGE" && dotf push
}

function menu {
	DOTF_OPT=$(gum choose "commit -a && push" "dotf diff" "dotf status -suno")
	[[ $DOTF_OPT =~ "commit" ]] && push
	[[ $DOTF_OPT =~ "diff" ]] && dotf diff
	[[ $DOTF_OPT =~ "status" ]] && dotf status -suno
}

[[ $1 =~ "menu" ]] && menu
[[ $1 =~ "push" ]] && push
