# ZFS Snapshots  

Before diving into building bhyve and jails, which I've never done, I want to put a safety net in place.  

I'll do this with a cronjob to take a daily snapshot of zroot and the 2 important mount points from earlier.  

[Klara Article](https://klarasystems.com/articles/basics-of-zfs-snapshot-management/)  
[OpenZFS Rolling Snapshot](https://openzfs.github.io/openzfs-docs/man/master/8/zfs-snapshot.8.html)  

Gather names of items to snapshot  
```bash
zfs list

NAME                 USED  AVAIL  REFER  MOUNTPOINT
nas01               94.1G  28.9T  94.1G  /nas01
nas01/documents      512K  28.9T   512K  /nas01/documents
nas01/photos         512K  28.9T   512K  /nas01/photos
zroot               2.30G  96.5G    96K  /zroot
zroot/ROOT          1.50G  96.5G    96K  none
zroot/ROOT/default  1.50G  96.5G  1.50G  /
zroot/home          2.02M  96.5G    96K  /home
zroot/home/mlitsey  1.93M  96.5G  1.93M  /home/mlitsey
zroot/tmp            120K  96.5G   120K  /tmp
zroot/usr            814M  96.5G    96K  /usr
zroot/usr/ports      814M  96.5G   814M  /usr/ports
zroot/usr/src         96K  96.5G    96K  /usr/src
zroot/var            956K  96.5G    96K  /var
zroot/var/audit       96K  96.5G    96K  /var/audit
zroot/var/crash       96K  96.5G    96K  /var/crash
zroot/var/log        412K  96.5G   412K  /var/log
zroot/var/mail       160K  96.5G   160K  /var/mail
zroot/var/tmp         96K  96.5G    96K  /var/tmp
```

I want to snapshot `/nas01/documents`, `/nas01/photos`, and `zroot`.  

The rolling snapshots should look like this....I think  

Documents
```bash
# document_snap
zfs destroy -r nas01/documents@7daysago
zfs rename -r nas01/documents@6daysago @7daysago
zfs rename -r nas01/documents@5daysago @6daysago
zfs rename -r nas01/documents@4daysago @5daysago
zfs rename -r nas01/documents@3daysago @4daysago
zfs rename -r nas01/documents@2daysago @3daysago
zfs rename -r nas01/documents@yesterday @2daysago
zfs rename -r nas01/documents@today @yesterday
zfs snapshot -r nas01/documents@today
```

Photos
```bash
# photos_snap
zfs destroy -r nas01/photos@7daysago
zfs rename -r nas01/photos@6daysago @7daysago
zfs rename -r nas01/photos@5daysago @6daysago
zfs rename -r nas01/photos@4daysago @5daysago
zfs rename -r nas01/photos@3daysago @4daysago
zfs rename -r nas01/photos@2daysago @3daysago
zfs rename -r nas01/photos@yesterday @2daysago
zfs rename -r nas01/photos@today @yesterday
zfs snapshot -r nas01/photos@today
```

zroot  
```bash
# zroot_snap
zfs destroy -r zroot@7daysago
zfs rename -r zroot@6daysago @7daysago
zfs rename -r zroot@5daysago @6daysago
zfs rename -r zroot@4daysago @5daysago
zfs rename -r zroot@3daysago @4daysago
zfs rename -r zroot@2daysago @3daysago
zfs rename -r zroot@yesterday @2daysago
zfs rename -r zroot@today @yesterday
zfs snapshot -r zroot@today
```

created script [/usr/local/bin/zfs_snap.sh](./zfs_snap.sh)  

[list snapshots](https://docs.oracle.com/cd/E19253-01/819-5461/gbiqe/index.html) after script has ran  
```bash
zfs list -t snapshot

NAME                       USED  AVAIL  REFER  MOUNTPOINT
nas01/documents@today        0B      -   512K  -
nas01/photos@today           0B      -   512K  -
zroot@today                  0B      -    96K  -
zroot/ROOT@today             0B      -    96K  -
zroot/ROOT/default@today   400K      -  1.50G  -
zroot/home@today             0B      -    96K  -
zroot/home/mlitsey@today     0B      -  1.93M  -
zroot/tmp@today              0B      -   120K  -
zroot/usr@today              0B      -    96K  -
zroot/usr/ports@today        0B      -   814M  -
zroot/usr/src@today          0B      -    96K  -
zroot/var@today              0B      -    96K  -
zroot/var/audit@today        0B      -    96K  -
zroot/var/crash@today        0B      -    96K  -
zroot/var/log@today         84K      -   424K  -
zroot/var/mail@today         0B      -   160K  -
zroot/var/tmp@today          0B      -    96K  -
```