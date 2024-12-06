# Administrative Tasks 

## Disable ssh password login  

I used this [guide](https://iampusateri.com/posts/sshd-config/)  

[Powershell ssh-copy-id](https://superuser.com/questions/1747549/alternative-to-ssh-copy-id-on-windows)  
```bash
# create ssh key
ssh-keygen -t ed25519

# copy key to server
# make sure to use the ".pub" file 
ssh-copy-id $user@$server
    # or
ssh-copy-id -i ~/.ssh/$key.pub $user@$server
ssh-copy-id -i ~/.ssh/mal-CR10.pub lf_test@192.168.35.24

# copy key from windows powershell to server
type $env:USERPROFILE\.ssh\$key.pub | ssh $user@$server "cat >> .ssh/authorized_keys"


# test key based login
ssh $user@$server
    # or
ssh -i ~/.ssh/$key $user@$server
ssh -i ~/.ssh/mal-CR10 lf_test@192.168.35.24

# disable ssh password authentication
vim /etc/rc.conf
sshd_enable="YES"
sshd_flags="-o KbdInteractiveAuthentication=no"

# restart ssh service
service sshd restart
```

If you use [this](https://unix.stackexchange.com/questions/654081/different-ways-of-disabling-password-logins-on-freebsd) method `pw mod user $user -w no`  
Then you won't be able to use sudo  

## Enable periodic scripts

[Handbook](https://docs.freebsd.org/en/books/handbook/config/#cron-periodic)  

```bash
sudo su -
# set non default settings
vim /etc/periodic.conf
daily_scrub_zfs_enable="YES"
daily_output="/var/log/daily.log"
weekly_output="/var/log/weekly.log"
monthly_output="/var/log/monthly.log"
daily_status_security_output="/var/log/security_daily.log"
weekly_status_security_output="/var/log/security_weekly.log"
monthly_status_security_output="/var/log/security_monthly.log"
```

## Set root crontab
```bash
crontab -e
#+------------ Minute            (range: 0-59)
#| +---------- Hour              (range: 0-23)
#| | +-------- Day of the Month  (range: 1-31)
#| | | +------ Month of the Year (range: 1-12)
#| | | | +---- Day of the Week   (range: 1-7, 1 standing for Monday)
#| | | | |

0 21 * * * /usr/local/bin/zfs_snap.sh
# do daily/weekly/monthly maintenance
0 2 * * * root periodic daily
0 3 * * 6 root periodic weekly
0 5 1 * * root periodic monthly
```

## setup tailscale VPN  

[tailscale](https://tailscale.com/)  

I prefer using this to connect my devices remotely.  
You can have up to 100 devices free.  

```bash
pkg install tailscale
sysrc tailscaled_enable=“YES”
service tailscaled start
# may have to use onestart
service tailscaled onestart
tailscale login
# copy URL and use it to login to account 
To authenticate, visit:

        https://login.tailscale.com/$your_unique_url

Success.
```

## Adjust server fan speed  

My fans were running at 45% at the lowest settting. I found [this](https://jono-moss.github.io/post/dell-r710-how-to-quiet-the-fans/) awesome write up on how to schedule a cronjob to change it. 

I had already setup the IPMI so skipped down to installing `ipmitool`

```bash
pkg search ipmitool
pkg install ipmitool

# test
ipmitool -I lanplus -H $IP -U fan-admin -P $PASSWORD -y 0000000000000000000000000000000000000000 sdr type temperature
ipmitool -I lanplus -H $IP -U fan-admin -P $PASSWORD -y 0000000000000000000000000000000000000000 sdr type temperature |grep Exhaust |grep degrees |grep -Po '\d{2}' | tail -1)
```

I was able to get a reply and moved on with creating the script with some changes.

This server only has 4 temps so I based the reading on the Exhaust and wanted the fan to run longer to drop the temp then idle at 9% until over the MAXTEMP variable. 

```bash
vim /usr/local/bin/setspeed.sh

#!/usr/bin/env bash

# IPMI IP address
IPMIHOST=$IP
# IPMI Username
IPMIUSER=fan-admin
# IPMI Password
PASSWORD=$(cat ~/fa.txt)
IPMIPW=$PASSWORD
# Your IPMI Encryption Key
IPMIEK=0000000000000000000000000000000000000000
# Fan Speed / utilisation in percentage, for example 9 for 9% utilisation
# Please note that each fan can have a different rpm and will not all be the same speed
FANSPEED=9

# TEMPERATURE
# Change this to the temperature in Celsius you are comfortable with.
# If the temperature goes above the set degrees it will send raw IPMI command to enable dynamic fan control
MAXTEMP=35
MINTEMP=28

# This variable sends a IPMI command to get the temperature, and outputs it as two digits.
# Do not edit unless you know what you do.
# Side note, if you are running ipmitool on the system you are controlling, you don't need to specify -H,-U,-P - from the OS installed on the host, ipmitool is assumed permitted. You only need host/user/pass for remote access.
TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK sdr type temperature |grep Exhaust |grep degrees |grep -Po '\d{2}' | tail -1)

# Dont edit this, this converts decimal to hex
SPEEDHEX=$( printf "%x" $FANSPEED )

if [[ $TEMP > $MAXTEMP ]];
  then
    printf "Warning: Temperature is too high! Activating dynamic fan control! ($TEMP C)" | systemd-cat -t R730xd-IPMI-TEMP
    echo "Warning: Temperature is too high! Activating dynamic fan control! ($TEMP C)"
    # This sets the fans to auto mode, so the motherboard will set it to a speed that it will need do cool the server down
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x01
elif [[ $TEMP < $MINTEMP ]];
  then
    printf "Temperature is OK ($TEMP C)" | systemd-cat -t R730xd-IPMI-TEMP
    printf "Activating manual fan speeds! (3120 RPM)"
    # This sets the fans to manual mode
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x00
    # This is where we set the slower, quiet speed
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x02 0xff 0x$SPEEDHEX
  else
          printf "Keeping settings the same until it needs to be changed, Temp is ($TEMP C)" | systemd-cat -t R730xd-IPMI-TEMP
fi

# set in crontab
chmod 750 setspeed.sh
crontab -e 
*/1 * * * * /usr/local/bin/setspeed.sh > /dev/null 2>&1

# check log for output
tail -f /var/log/syslog
```

