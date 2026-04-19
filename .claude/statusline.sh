#!/bin/bash

# Claude Code statusline script with prompt preview
# Follows official patterns from https://code.claude.com/docs/en/statusline

# Parse JSON input from Claude Code
parse_input() {
	local input
	input=$(cat)
	{ read -r current_dir; read -r model_display; read -r transcript_path; read -r ctx_pct; read -r session_cost; read -r total_input; read -r total_output; read -r rl_5h; read -r rl_7d; } < <(
		jq -r '
			(.workspace.current_dir // .cwd),
			(.model.display_name // "Claude"),
			(.transcript_path // ""),
			(.context_window.used_percentage // "" | if type == "number" then (. | round | tostring) else "" end),
			(.cost.total_cost_usd // 0 | if . > 0 then ("$" + (. * 100 | round / 100 | tostring)) else "" end),
			(.context_window.total_input_tokens // 0 | if . >= 1000000 then (((. / 100000 | floor) / 10 | tostring) + "M") elif . >= 1000 then (((. / 100 | floor) / 10 | tostring) + "k") else tostring end),
			(.context_window.total_output_tokens // 0 | if . >= 1000000 then (((. / 100000 | floor) / 10 | tostring) + "M") elif . >= 1000 then (((. / 100 | floor) / 10 | tostring) + "k") else tostring end),
			(.rate_limits.five_hour.used_percentage // "" | if type == "number" then (. | round | tostring) else "" end),
			(.rate_limits.seven_day.used_percentage // "" | if type == "number" then (. | round | tostring) else "" end)
		' <<< "$input"
	)
}

# Get git branch with status indicator
get_git_info() {
	git_info=""

	if git -C "$current_dir" rev-parse --is-inside-work-tree &>/dev/null; then
		branch=$(git -C "$current_dir" symbolic-ref --short HEAD 2>/dev/null || \
		         git -C "$current_dir" rev-parse --short HEAD 2>/dev/null)
		[[ -n "$branch" ]] && git_info=" $branch"
	fi
}

# Extract latest user prompt from JSONL transcript
get_prompt_preview() {
	prompt_preview=""

	if [[ -n "$transcript_path" && -f "$transcript_path" ]]; then
		local user_lines
		user_lines=$(rg '"type":"user"' "$transcript_path" 2>/dev/null | rg -v '"isMeta":true' | rg -v 'tool_result' | tail -n 10)

		if [[ -n "$user_lines" ]]; then
			local latest_prompt
			latest_prompt=$(tac <<< "$user_lines" | jq -rn '
				first(
					inputs |
					if (.message.content | type) == "array" then
						(.message.content[] | select(.type == "text").text | select(length > 0))
					else
						(.message.content | select(type == "string" and length > 0))
					end
				) // empty
			' 2>/dev/null)

			if [[ -n "$latest_prompt" ]]; then
				local cleaned
				cleaned=$(sed 's/<[^>]*>//g; s/[[:space:]]\+/ /g; s/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$latest_prompt")
				if [[ -n "$cleaned" ]]; then
					local original_len truncated
					read -r original_len truncated < <(awk '{print length($0), substr($0,1,60)}' <<< "$cleaned")
					[[ $original_len -gt 60 ]] && truncated="${truncated}..."
					local icon_kb=$'\uf11c'
					prompt_preview="${icon_kb}: $truncated"
				fi
			fi
		fi
	fi
}

# Build and display the statusline
build_statusline() {
	local ctx_display="" ctx_color
	if [[ -n "$ctx_pct" ]]; then
		if [[ $ctx_pct -ge 80 ]]; then
			ctx_color="\033[01;31m"
		elif [[ $ctx_pct -ge 50 ]]; then
			ctx_color="\033[01;33m"
		else
			ctx_color="\033[01;32m"
		fi
		ctx_display=" ${ctx_color}${ctx_pct}%\033[00m"
	fi

	# Line 1: dir + git + model + ctx + cost + tokens + rate limits
	local icon_in=$'\uf019' icon_out=$'\uf093' icon_5h=$'\uf017' icon_7d=$'\uf073'
	local rl5_clr rl7_clr
	local line1="\033[01;34m${dir_name}\033[00m${git_info} \033[01;36m[${model_display}]\033[00m"
	[[ -n "$ctx_pct" ]] && line1+="$ctx_display"

	[[ -n "$session_cost" ]] && line1+=" \033[33m${session_cost}\033[00m"
	line1+=" \033[02m${icon_in} ${total_input} ${icon_out} ${total_output}\033[00m"

	if [[ -n "$rl_5h" ]]; then
		if [[ $rl_5h -ge 80 ]]; then rl5_clr="\033[31m"
		elif [[ $rl_5h -ge 50 ]]; then rl5_clr="\033[33m"
		else rl5_clr="\033[32m"; fi
		line1+=" ${icon_5h} \033[02m5h:\033[00m${rl5_clr}${rl_5h}%\033[00m"
	fi

	if [[ -n "$rl_7d" ]]; then
		if [[ $rl_7d -ge 80 ]]; then rl7_clr="\033[31m"
		elif [[ $rl_7d -ge 50 ]]; then rl7_clr="\033[33m"
		else rl7_clr="\033[32m"; fi
		line1+=" ${icon_7d} \033[02m7d:\033[00m${rl7_clr}${rl_7d}%\033[00m"
	fi

	printf "%b\n" "$line1"

	# Line 2: prompt preview
	[[ -n "$prompt_preview" ]] && printf "%s\n" "$prompt_preview"
}

# Main execution
main() {
	parse_input
	dir_name="${current_dir##*/}"
	get_git_info
	get_prompt_preview
	build_statusline
}

# Run the script
main
