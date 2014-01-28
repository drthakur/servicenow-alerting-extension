#!/bin/bash
logdir=../../logs
logfile=$logdir"/serviceNowClient.log"
touch $logfile

./createServiceNowTicket.sh  "$@">> $logfile 2>&1

MAX_LOG_FILE_SIZE_IN_BYTES=5242880
if [`stat -c %s $logfile` -gt $MAX_LOG_FILE_SIZE_IN_BYTES]; then
	timestamp=`date +%Y%m%d`
	archivelogfile=$logfile.$timestamp
	cp $logfile $archivelogfile
	cat /dev/null > $logfile
	find $logdir -name "serviceNowClient.log.*" -type f -mtime +90 | xargs rm -f 
fi
