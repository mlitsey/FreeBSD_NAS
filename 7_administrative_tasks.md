# Administrative Tasks 

## Disable ssh password login  

I used this [guide](https://iampusateri.com/posts/sshd-config/)  

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

