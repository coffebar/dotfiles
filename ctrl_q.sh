#!/bin/bash

# Terminate active Google Chrome browser (with -TERM signal), 
# including all windows and sessions, for current user

FOCUSED_WIN_TITLE=$(xdotool getwindowfocus getwindowname)
CHROME_REGEX=" - Google Chrome$"
CHROME_PROCESS="/opt/google/chrome/chrome"

[[ $FOCUSED_WIN_TITLE =~ $CHROME_REGEX ]] && pkill --uid $UID --full $CHROME_PROCESS