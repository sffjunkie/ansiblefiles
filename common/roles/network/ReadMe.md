# Network

## Connection Types

* wireless
* ethernet

## IP allocation

* static ip
* dynamic ip (dhcp)

## Stages

* iwd - connect to wifi
* networkd - allocate an id
* resolved - resolve hosts

## Wireless

iwd -> networkd -> resolved

## Wired

networkd -> resolved
