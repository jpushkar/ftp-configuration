#!/bin/bash
FIND=/usr/bin/find
RSYNC=/usr/bin/rsync
SOURCE=/opt/sftp/akamai/
#SOURCE=/home/pushkar/test-dir/
TARGET=/gcs-akamai-rawlogs-bucket/akamai-rawlogs/
#TARGET=/home/pushkar/dest-dir/
INTERVAL=30
FILELIST=/tmp/filelist.$(date +%s)

time=`date "+%d-%m-%Y-%H-%M-%S"`

cd $SOURCE
$FIND . -type f -mmin +$INTERVAL > $FILELIST
cat $FILELIST

if [ $(cat $FILELIST | wc -l) -ne "0" ]
then
   $RSYNC -av --log-file=/home/pushkar/rsync-$time.log --remove-source-files --files-from=$FILELIST $SOURCE/ $TARGET/
#   $RSYNC -av --log-file=/home/pushkar/rsync-$time.log --files-from=$FILELIST $SOURCE/ $TARGET/
   $RSYNC -av --log-file=/home/pushkar/rsync.log --remove-source-files /home/pushkar/rsync-$time.log /gcs-akamai-rawlogs-bucket/rsync-logs/
fi
