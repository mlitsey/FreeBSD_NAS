#!/usr/bin/env bash

# Location = /usr/local/bin/zfs_snap.sh
#set -x # enables debugging
#set -e # bash will exit on error
#printf " \n\n Don't forget to check /var/log/syslog or /var/log/cron for cronjob script run times \n\n"

LOG=/var/log/zfs_snap_$(date +"%F_%H.%M.%S").log
touch ${LOG}
# Zero out log file, redirect all STDIN and STDERR output to log file
exec >"${LOG}" 2>&1

printf "\n\n %s - Starting Script /usr/local/bin/zfs_snap.sh \n\n" "$(date)"

printf " \n\n Don't forget to check /var/log/syslog or /var/log/cron for cronjob script run times \n\n"

printf " \n\n Removing old logs from /var/log/ \n\n"
find /var/log/ -type f -name "zfs_snap*.log" -mtime +7 |xargs rm 

printf " \n\n New log file is %s \n\n" "${LOG}"

printf " \n\n Cycling /nas01/documents zfs snapshot \n\n"
zfs destroy -r nas01/documents@7daysago
zfs rename -r nas01/documents@6daysago @7daysago
zfs rename -r nas01/documents@5daysago @6daysago
zfs rename -r nas01/documents@4daysago @5daysago
zfs rename -r nas01/documents@3daysago @4daysago
zfs rename -r nas01/documents@2daysago @3daysago
zfs rename -r nas01/documents@yesterday @2daysago
zfs rename -r nas01/documents@today @yesterday
zfs snapshot -r nas01/documents@today


printf " \n\n Cycling /nas01/photos zfs snapshot \n\n"
zfs destroy -r nas01/photos@7daysago
zfs rename -r nas01/photos@6daysago @7daysago
zfs rename -r nas01/photos@5daysago @6daysago
zfs rename -r nas01/photos@4daysago @5daysago
zfs rename -r nas01/photos@3daysago @4daysago
zfs rename -r nas01/photos@2daysago @3daysago
zfs rename -r nas01/photos@yesterday @2daysago
zfs rename -r nas01/photos@today @yesterday
zfs snapshot -r nas01/photos@today


printf " \n\n Cycling /zroot/ zfs snapshot \n\n"
zfs destroy -r zroot@7daysago
zfs rename -r zroot@6daysago @7daysago
zfs rename -r zroot@5daysago @6daysago
zfs rename -r zroot@4daysago @5daysago
zfs rename -r zroot@3daysago @4daysago
zfs rename -r zroot@2daysago @3daysago
zfs rename -r zroot@yesterday @2daysago
zfs rename -r zroot@today @yesterday
zfs snapshot -r zroot@today

printf "\n\n List snapshots \n\n"
zfs list -t snapshot

# End of script
printf "\n\n %s - Script Complete \n\n" "$(date)"