#!/bin/bash
# Script waits for archive files downloaded by Telegram 
# and extracts them to the upper directory "Downloads"

cd "$(dirname "$0")"
inotifywait --format '%f' -m -e close_write -e moved_to "./" |\
(
while read
do
    FILE_EXT=$(echo $REPLY | grep --only-matching --ignore-case -P "\.(zip|rar|7z)$")
    if [ "$FILE_EXT" != "" ]
    then
      DIR_NAME=$(basename "$REPLY" $FILE_EXT)
      echo $DIR_NAME
      file-roller --extract-here "$REPLY" && mv "$DIR_NAME" ../
    fi
done
)
