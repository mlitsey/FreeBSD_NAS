# Installing FreeBSD 14.1 Release  

## Issues  
mfi driver causing I/O errors on install  
BIOS settings  
RAID controller

## BIOS fix 
1. Update all firmware through Life Cycle Controller  
2. X2APIC setting for the CPUs must be disabled  
    - this was already set correctly  

## RAID fix
set to HBA mode to pass through disks  
- Cleared RAID configuration  
- [Set to HBA mode](https://www.dell.com/support/manuals/en-us/poweredge-rc-h730/perc9ugpublication/switching-the-controller-to-hba-mode?guid=guid-1fcc87e1-d534-451a-9947-56f1175886c5&lang=en-us)  

## mfi driver fix  
on boot enter the loader prompt (option 3 for me)
- [FreeBSD Handbook Page](https://docs.freebsd.org/en/books/handbook/bsdinstall/#bsdinstall-view-probe)  

`set hw.mfi.mrsas_enable="1"`  
`autoboot`  
at the end of the install enter the shell and edit `/boot/loader.conf`  
add `hw.mfi.mrsas_enable="1"`  

## Install options
1. Install  
2. Continue with default keymap  
3. Set Hostname = NAS  
4. Distribution Select = kernel-dbg, lib32, ports  
5. Partitioning = Auto (ZFS)  
    - Pool Type/Disks = Mirror with the 2 x 128 GB drives  
    - Swap Size = 16g  
    - everything else as default  
6. Set the password  
7. Network Configuration = select the 1 port I had plugged in. I had a cable in port 1 on the hardware but it ended up being port bge2 instead of bge0. I found this by using DHCP setup which failed on the other ports.  
8. IPv6 = No  
9. Time Zone = UTC  
    - I chose this to not have to deal with Daylight Savings Time  
10. Time and Date = These were already correct for me  
11. System Configuration = sshd, ntpd_sync, dumpdev  
12. System Hardening = None  
13. Add Users = Yes  
    - added to the wheel group  
    - keep the remaining defaults and set password  
14. Apply configuration and exit  
15. Manual Configuration  
    - Yes to enter the shell  
    - `vi /boot/loader.conf`
    - add `hw.mfi.mrsas_enable="1"` to the end of the file  
    - exit back to menu  
16. Shutdown
    - Once shut down remove the USB installer and power on  

## Post install setup  

ssh to the server  
- `ssh 192.168.1.24`  

Install Software  
```bash
su -
pkg
pkg install vim, 