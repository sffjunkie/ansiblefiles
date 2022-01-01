# Backup

Backs up data from

* Laptop
    * music, pictures etc.
* Servers
    * Service configuration
    * Service data

## Targets

* OneDrive - Via TrueNAS NFS mount or directly by rclone?
* Google Drive - Via TrueNAS NFS mount or directly by rclone?
* NAS - NFS mount
* Offsite - Backup server
* USB HD
* Encrypt before uploading - gpg


## Services to backup

* unifi
* postgresql
* mongo
* influxdb
* deconz
* mosquitto
* telegraf
* webserver
* gitlab
* gitlab runner

## Data to backup

* Pictures
* Documents
* Development
* Music
* Videos
* Service files
* Service data

/home/development
~/.local/share/gnupg/

## Local Storage

mounts
* nfs
* cifs

## Offsite Storage

`rclone`

## Retention / Pruning

Start of Week - Mon

Day of Month
Day of Week - List(Mon, Tue) or range
Hour of Day

Monthy
Weekly
Daily
Hourly

Keep last n
Keep last n Monthy
Keep last n Weekly
Keep last n Daily
Keep last n Hourly

## Proxmox

Proxmox -> Local storage (`vzdump`) -> Offsite storage (`rclone`)

### filename regex

2 types of backup - qemu and lxc

qemu extension = `vma`
lxc extension = `tar`

compression methods

gzip
lzo
zstd
none

Standard Promoxox
vzdump-{dump_type}-{vmid}-{date}-{time}.{extension}[.{compression}]

Custom Promoxox
vzdump-{dump_type}-{proxmox_node}-{vm_id}-{vm_name}-{date}-{time}.{extension}[.{compression}]


### Logs

{date} 15:34:39 INFO: Finished Backup of VM 501 (00:00:58)

Prune match
Prune keep


## Logging
