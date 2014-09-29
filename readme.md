# Meson scripts
Transfer file from MR server to `wallace.wpic.upmc.edu`. 

Previous automation pulled from `meson` while on `wallace`.  This previous direction was sub-optimal: need `expect` to enter password; wallace's uptime is unpredictable: transfers died with no real audit.

## Automation

 * these scripts are run on the MR data server (`meson`) via crontab. See `meson.crontab` 

## Files
 * 01_checkDaily.bash: use yesterday's date to find and validate `lunaid_date`s that might exist for any project, rsync to `wallace`
 * 00_linkAll.bash: link everything scan matching luna_date in `~/MRprojects/*/` to `~/MRlinks/*/luna_date`
   * check no links are made to that location in link dir, list of known links is in knownlinks
 * 00_rsync.bash: rsync everything over. look only for files that dont exist or have changed size

## Notes
 * use `skipme` file to ignore any e.g. malformed and dealt-with-by-hand `luna_date` directory on `meson`
   * directories with this file will never be linked and therefore never transfered to wallace
   * **DO NOT** put a `skipme` file in a directory whos link needs to be or has been named differently (e.g. to fix malformed date). The scripts check for links with different names before linking in missing directories already. Incorrectly named directories do not need to be skipped

## TODO
 * get physio
 * run things on wallaces side (FS, mprage preproc)
