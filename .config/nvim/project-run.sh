#!/bin/bash

# looking for *.sh files in project
SCRIPTS=$(rg --max-depth=2 --hidden --files --glob '*.sh')
if [ -z "$SCRIPTS" ]; then exit; fi
# give to select one via rofi\wofi
SELECTED=$(echo "$SCRIPTS" | ofi-menu)
# execute that file in bash
[ -n "$SELECTED" ] && [ -f "$SELECTED" ] && source "$SELECTED"
