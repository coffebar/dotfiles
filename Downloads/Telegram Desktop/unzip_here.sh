#!/bin/bash
# Extract archive files downloaded by Telegram into "Downloads"

pushd "$(dirname "$0")" || exit 1
inotifywait --format '%f' -m -e close_write -e moved_to "./" \
	| (
		while read -r; do
			FILE_EXT=$(echo "$REPLY" | grep --only-matching --ignore-case -P "\.(zip|rar|7z)$")
			if [ "$FILE_EXT" != "" ]; then
				DIR_NAME=$(basename "$REPLY" "$FILE_EXT")
				OUT_DIR="../$DIR_NAME"
				if [ ! -d "$OUT_DIR" ]; then
					mkdir "$OUT_DIR"
					if [ "$FILE_EXT" == ".zip" ] || [ "$FILE_EXT" == ".ZIP" ]; then
						unzip "$REPLY" -d "$OUT_DIR"
					elif [ "$FILE_EXT" == ".rar" ] || [ "$FILE_EXT" == ".RAR" ]; then
						unrar x "$REPLY" "$OUT_DIR"
					elif [ "$FILE_EXT" == ".7z" ] || [ "$FILE_EXT" == ".7Z" ]; then
						7z x "$REPLY" -o"$OUT_DIR"
					fi
				fi
			fi
		done
	)
