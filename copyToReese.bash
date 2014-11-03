#!/usr/bin/env bash

#
# copy cron and script to somewhere that has git
# so this can all be version tracked
#

message="auto update $(date +%F)"
[ -n "$1" ] && message=$1;

cd $(dirname $0)

crontab -l > meson.crontab
rsync *bash *rsync *md *crontab reese:~/src/mesonScripts/
ssh reese "cd ~/src/mesonScripts; git diff --exit-code >/dev/null || (git commit -am '$message'; git push)"

