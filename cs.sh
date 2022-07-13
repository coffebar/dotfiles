#!/bin/bash
killall rsibreak
pgrep -f /usr/lib/firefox | xargs kill
steam steam://rungameid/730
