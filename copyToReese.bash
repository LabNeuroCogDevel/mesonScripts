#!/usr/bin/env bash
message="auto update $(date +%F)"
[ -n "$1" ] && message=$1;

cd $(dirname $0)

crontab -l > meson.crontab
rsync *bash *rsync *md *crontab reese:~/src/mesonScripts/
ssh reese "cd ~/src/mesonScripts; git diff --exit-code >/dev/null || (git commit -am '$message'; git push)"

