#!/bin/bash
FIND=/usr/bin/find
RSYNC=/usr/bin/rsync
SOURCE=/opt/ftp/akamai/
#SOURCE=/home/pushkar/test-dir/
td=`date "+%d-%m-%Y"`
TARGET=/gcs-akamai-rawlogs-bucket-production/ftp/$td
#TARGET=/home/pushkar/dest-dir/
INTERVAL=30
FILELIST=/tmp/ftp-filelist.$(date +%s)
t1=`date "+%d-%m-%Y-%H-%M"`
LogfileName=rsync-$t1.log


cd $SOURCE
$FIND . -type f -mmin +$INTERVAL > $FILELIST
cat $FILELIST

if [ $(cat $FILELIST | wc -l) -ne "0" ]
then
   $RSYNC -av --log-file=/home/pushkar/$LogfileName --remove-source-files --files-from=$FILELIST $SOURCE/ $TARGET/
#   $RSYNC -av --log-file=/home/pushkar/$LogfileName --files-from=$FILELIST $SOURCE/ $TARGET/
   $RSYNC -av --log-file=/home/pushkar/rsync.log --remove-source-files /home/pushkar/$LogfileName /gcs-akamai-rawlogs-bucket-production/rsync-logs/
fi
