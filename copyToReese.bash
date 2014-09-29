#!/usr/bin/env bash
crontab -l > meson.crontab
rsync *bash *rsync *md *crontab reese:~/src/mesonScripts/
ssh reese "cd ~/src/mesonScripts; git diff --exit-code >/dev/null ||git commit -am 'auto update $(date +%F)'"

