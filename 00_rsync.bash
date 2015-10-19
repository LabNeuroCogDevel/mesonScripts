
opts="-zahiLv --chmod u=rwx,g=rx,o=rx -O --size-only --no-perms "
remote=foranw@wallace:/data/Luna1/Raw

rsync $opts /home/kaihwang/MRlinks/P5Sz/ $remote/P5Sz/ |tee Sz.rsync
rsync $opts /home/kaihwang/MRlinks/MultiModal/ $remote/MultiModal/ |tee MM.rsync
rsync $opts /home/kaihwang/MRlinks/Reward/ $remote/MRCTR/ |tee Rew.rsync
rsync $opts /home/kaihwang/MRlinks/WorkingMemory/ $remote/WorkingMemory/ |tee WM.rsync
rsync $opts /home/kaihwang/MRlinks/mMRDA-dev/ $remote/mMRDA-dev/ |tee mMRDA.rsync

