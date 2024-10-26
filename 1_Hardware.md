# Hardware  
This is the hardware choosen for the project.  

## Dell PowerEdge R730xd  
The server contained everything for this purchase price.  

$559.35 - Purchased used on [Amazon](https://www.amazon.com/dp/B07XSD81TM?ref=ppx_yo2ov_dt_b_fed_asin_title) 2024-10-21  

2 x E5-2660 v3 (Intel Xeon, 2600 MHz, 10 core)  
6 x 32 GB (192 GB installed, 24 empty slots, 3072 GB max)  
Broadcom Gigabit Ethernet BCM5720 (4 ports)  
2 x 1100W PSU (Part numbers 09TMRFA00, 0PR21CA00)  
PERC H730 Mini Raid Controller  
- Cleared RAID configuration  
- [Set to HBA mode](https://www.dell.com/support/manuals/en-us/poweredge-rc-h730/perc9ugpublication/switching-the-controller-to-hba-mode?guid=guid-1fcc87e1-d534-451a-9947-56f1175886c5&lang=en-us)  
- Allows passing the disk though to the OS  

12 x 4 TB HDD  
- plan to setup with ZFS raid Z3  

## Rear Drive Setup
$29.99 - Backplan Board Kit from [Amazon](https://www.amazon.com/dp/B08CK87P5G?ref=ppx_yo2ov_dt_b_fed_asin_title) 2024-10-21  
$14.99 - 2 x 2.5 inch Drive Trays  from [Amazon](https://www.amazon.com/dp/B091GW1B7R?ref=ppx_yo2ov_dt_b_fed_asin_title) 2024-10-21  
$15.99 each - 2 x 128G SSD from [Amazon](https://www.amazon.com/dp/B0963SGYGF?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1) 2024-10-21  
- for ZFS mirrored boot drives  

