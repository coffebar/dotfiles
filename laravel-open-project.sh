#!/bin/bash
# Open laravel dev env on Hyprland wayland compositor:
# start editor, browser, VM, show logs, run queue, build frontend, open terminal
# class needed to pin windows on workspaces

# first argument is project's dir
PROJECT=$1
# second is browser's profile dir, related to default config dir
CHROME_PROFILE=$2

ter (){
	$TERMINAL -o font.size=14 --working-directory=$PROJECT $@
}

workspace (){
	hyprctl dispatch workspace "$1" &
}

tear_up () {
	# run VM
	ter --class='wp-5' --command ./vendor/bin/sail up &

	# open editor
	ter --class='wp-3' --command nvim &

	workspace 5
	sleep 3

	# run queue jobs
	ter --class='wp-5' --command ./vendor/bin/sail artisan schedule:run &
	# auto build frontend
	ter --class='wp-5' --command ./vendor/bin/sail npm run dev &

	# switch workspaces
	workspace 4 # first display
	workspace 3 # second display


	# tail logs
	ter --class='wp-4' --command tail -f storage/logs/laravel.log &
	# run chrome
	google-chrome-stable --ozone-platform=wayland \
		--profile-directory="$CHROME_PROFILE" > /dev/null 2>&1 &
	sleep 1
	# open terminal
	ter --class='wp-4' &

}

tear_down () {
	pkill -2 -f "$TERMINAL -o font.size=14 --working-directory=$PROJECT"
	pkill -f "/opt/google/chrome/chrome" > /dev/null 2>&1
	ter --class='wp-5' --command ./vendor/bin/sail down &
}

if pgrep -af "profile-directory=$CHROME_PROFILE"; then
	tear_down
else
	tear_up
fi

disown
