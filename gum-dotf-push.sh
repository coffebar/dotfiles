#!/usr/bin/env /bin/zsh
function dotf {
	git --git-dir=$HOME/dotfiles --work-tree=$HOME "$@"
}
function push {
	# commit all dotfiles to github repo
	COMMIT_MESSAGE=$(gum input --placeholder 'Commit message') && dotf commit -a -m "$COMMIT_MESSAGE" && dotf push
}

function menu {
	DOTF_OPT=$(gum choose "diff" "commit -a && push" "status -suno" "status --untracked-files=all")
	[[ $DOTF_OPT =~ "commit" ]] && push
	[[ $DOTF_OPT =~ "diff" ]] && dotf diff
	[[ $DOTF_OPT =~ "status" ]] && dotf status -suno
	[[ $DOTF_OPT =~ "untracked" ]] && dotf status --untracked-files=all
}

[[ $1 =~ "menu" ]] && menu
[[ $1 =~ "push" ]] && push
