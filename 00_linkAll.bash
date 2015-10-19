#!/usr/bin/env bash

scriptdir=$(cd $(dirname $0);pwd)

for proj in ~/MRprojects/*; do
 # pet is special
 [ "$proj" == "mMRDA-dev" ] && continue
 # actual path
 rawdir="$(readlink $proj)"
 # not a link, skip
 [ -z "$rawdir" ] && continue


 # get project name
 p=$(basename $proj)
 linkdir="$HOME/MRlinks/$p"
 linklist="$scriptdir/knownlinks/$(basename $proj)_knownlinks"

 [ ! -d  $linkdir ] && mkdir $linkdir
 
 ls -d $linkdir/*/ | xargs -n 1 readlink -f > $linklist
 
 find $rawdir -maxdepth 2 -type d -name '[0-9][0-9][0-9][0-9][0-9][_-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' | while read  f; do
   # get cononical path
   f=$(readlink -f $f)

   # skip known bads
   [ -r $f/skipme ] && continue

   # remove "-" to "_" if in scan dir subject id name 
   subjid=$(basename $f)
   subjid=${subjid//-/_}
   savename="$linkdir/$subjid"

   # skip if we already have the link
   if [ -h "$savename" ]; then
      linkis=$(readlink $savename)
      [ "$linkis" == "$f" ] && continue
      echo "!!! link $savename points to $linkis not $f"

   # maybe we accedpentally copied something here
   elif [ -r "$savename" ]; then
      echo "$savename exists but is not a link (should point to $f)"
      stat $savename

   # or we linked this to a btter name
   elif grep "$f" $linklist 1>/dev/null; then
      echo "$f linked elsewhere"

   # NOW WE CAN LINK
   else
      echo "linking $f to $savename"
      ln -s $f $savename
   fi

 done

 # dead links
 #echo "$p DEADLINKS"
 #find $proj -maxdepth 1 -type l ! -exec test -r {} \; -print | sed -e "s/^/\t/"
 
 # unlink nested links
 #for f in */; do l=$f/$(basename $f); [ -h $l ] && unlink $l; done

done
