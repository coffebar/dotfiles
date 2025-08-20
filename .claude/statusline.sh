#!/bin/bash

# Claude Code statusline script with prompt preview
# Follows official patterns from https://docs.anthropic.com/en/docs/claude-code/statusline

# Parse JSON input from Claude Code
parse_input() {
	local input
	input=$(cat)
	current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
	model_display=$(echo "$input" | jq -r '.model.display_name // "Claude"')
	transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')
}

# Get directory name using official pattern
get_directory_info() {
	dir_name="${current_dir##*/}" # Extract just the directory name
}

# Get git branch with status indicator
get_git_info() {
	git_info=""

	# Check if we're in a git repository
	if [[ -d "$current_dir/.git" ]]; then
		cd "$current_dir" 2> /dev/null || exit 1

		# Get current branch name (or commit hash if detached)
		branch=$(git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)

		if [[ -n "$branch" ]]; then
			git_info="  $branch"
		fi
	fi
}

# Extract latest user prompt from JSONL transcript
get_prompt_preview() {
	prompt_preview=""
	local latest_prompt

	# Only process if transcript file exists
	if [[ -n "$transcript_path" && -f "$transcript_path" ]]; then

		# Use ripgrep to efficiently find only user messages (not meta or tool results)
		# This pre-filters to only lines that are actual user text messages
		user_lines=$(rg '"type":"user"' "$transcript_path" 2> /dev/null | rg -v '"isMeta":true' | rg -v 'tool_result' | tail -n 10)

		# Process only the filtered lines to find the latest valid user message
		latest_prompt_result=$(echo "$user_lines" | tac | while IFS= read -r line; do
			# Parse the pre-filtered JSONL line
			content=$(echo "$line" | jq -r '
				if (.message.content | type) == "array" then 
					.message.content[] | select(.type == "text").text 
				else 
					.message.content 
				end
			' 2> /dev/null)

			# If we found content, clean it and exit
			if [[ -n "$content" ]]; then
				# Remove XML tags and clean whitespace
				cleaned=$(echo "$content" | sed 's/<[^>]*>//g' | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
				# Skip if it's empty after cleaning
				if [[ -n "$cleaned" && ! "$cleaned" =~ ^[[:space:]]*$ ]]; then
					# Use awk for Unicode-safe character truncation
					original_len=$(echo "$cleaned" | awk '{print length}')
					truncated=$(echo "$cleaned" | awk '{print substr($0, 1, 40)}')
					echo "$truncated|$original_len"
					break
				fi
			fi
		done)

		# Extract the truncated text and check if ellipsis is needed
		if [[ -n "$latest_prompt_result" ]]; then
			latest_prompt="${latest_prompt_result%%|*}"
			original_length="${latest_prompt_result##*|}"
		fi

		# Add to statusline if we found something
		if [[ -n "$latest_prompt" ]]; then
			# Add ellipsis if we truncated (original was longer than 40 characters)
			[[ $original_length -gt 40 ]] && latest_prompt="${latest_prompt}..."
			prompt_preview=" 💬 \"$latest_prompt\""
		fi
	fi
}

# Build and display the statusline
build_statusline() {
	printf "\033[01;92m%s@%s\033[00m:\033[01;34m%s\033[00m%s \033[01;36m[%s]\033[00m%s\n" \
		"$(whoami)" "$(hostname -s)" "$dir_name" "$git_info" "$model_display" "$prompt_preview"
}

# Main execution
main() {
	parse_input
	get_directory_info
	get_git_info
	get_prompt_preview
	build_statusline
}

# Run the script
main