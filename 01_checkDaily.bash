#!/usr/bin/env bash
scriptdir=$(cd $(dirname $0);pwd)

# quicker version of 00_linkAll.bash
# - gets yesterdays date and format for MR nameing convention
# - check yesterday for scans
#     - complain about scans that don't match luna_date
#     - link matches to ~/MRlink


scanfolderfmt=%Y.%m.%d-

for proj in ~/MRprojects/*; do
 # actual path
 rawdir="$(readlink $proj)"
 # not a link, skip
 [ -z "$rawdir" ] && continue


 # get project name
 p=$(basename $proj)
 linkdir="$HOME/MRlinks/$p"
 [ ! -d  $linkdir ] && mkdir $linkdir

 # set pname as WorkingMemory, MultiModal, or Reward
 # should match wallace:/data/Luna1/Raw
 pname=$p
 [[ $pname =~ Reward ]] && pname=Reward

 # what is yesterday in MR convention
 dirlist="$rawdir/$(date --date yesterday +$scanfolderfmt)*"
 [ $(ls $dirlist 2>/dev/null|wc -l) -lt 1 ] && continue

 find $dirlist -maxdepth 1 -mindepth 1 -type d | while read scan; do
    scan=$(readlink -m $scan) # remove extra /'s

    [ -r $scan/skipme ] && continue

    scandir=$(basename $scan)

    ## check date is right
    luna=${scandir%_*};luna_expect="^[0-9][0-9][0-9][0-9][0-9]$";
    dt=${scandir#*_};  dt_expect=$(date --date yesterday +%Y%m%d);

    bad="";
    if [ "$dt" != "$dt_expect" ]; then
      bad="\t$dt is not $dt_expect!\n$bad"
    fi
    if ! [[ "$luna" =~ $luna_expect ]]; then
      bad="\t$luna is not like $luna_expect!\n$bad"
    fi
    if [ -n "$bad" ]; then
      echo "BAD NAME: $scan "
      echo -en "$bad"
      echo -e "\trename $scan to fix "
      echo -e "\tor echo '[\$(date)] skip because ...' > $scan/skipme"
      continue
    fi

    ##  link!
  
    savename="$linkdir/$(basename $scan)"

    if [ -h "$savename" ]; then
       linkis=$(readlink $savename)
       [ "$linkis" == "$scan" ] && continue
       echo "!!! link $savename points to $linkis not $scan"
       continue
   elif [ -r "$savename" ]; then
      echo "$savename exists but is not a link (should point to $scan)"
      stat $savename
      continue
    else
       echo "linking $scan to $savename"
       ln -s $scan $savename
       rsync -avzL --chmod u=rwx,g=rx,o=rx $savename foranw@wallace:/data/Luna1/Raw/$pname/ >> $scriptdir/log.txt
    fi
 
 done
 
 

done
