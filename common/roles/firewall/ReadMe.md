# firewall

> **Note**: Currently Debian only

Ensure the firewall is installed, configure and enable it.

* Install firewall
* Set default rules; outgoing = allow, incoming = deny
* Allow ssh, http and https through the firewalll

Custom ports can be configured by setting the `custom_ports` variable
to a list of dicts with `rule`, `port` and `proto` keys.
