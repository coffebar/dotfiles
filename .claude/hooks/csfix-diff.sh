#!/usr/bin/env bash

# Read stdin synchronously FIRST ? must happen before any forking
input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')

# Only process PHP files
[[ "$file" == *.php ]] || exit 0

# Walk up from file's directory to find nearest Makefile with csfix-diff target
dir=$(dirname "$file")
while [[ "$dir" != "/" ]]; do
	if [[ -f "$dir/Makefile" ]]; then
		if grep -q '^csfix-diff:' "$dir/Makefile"; then
			# Fork to background ? Claude is not blocked, no output in context window
			(cd "$dir" && make csfix-diff > /dev/null 2>&1) &
		fi
		exit 0
	fi
	dir=$(dirname "$dir")
done
