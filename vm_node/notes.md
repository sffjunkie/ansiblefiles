# Notes

## Resize VM disk

```
qm resize <vmid> scsi0 +20G
```

Resize disk in `cfdisk`

```
pvresize /dev/sda3
lvresize -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
resize2fs /dev/ubuntu-vg/ubuntu-lv
```
