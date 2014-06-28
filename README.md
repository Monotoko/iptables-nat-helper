iptables-nat-helper
===================

Simple interface to iptables to help set up a NAT between two interfaces.

Instructions
===========

This is a simple interface I created just for dealing with NAT without having to remember the various iptables commands. Thought it might come in useful for someone out there. Note that I have developed and used this on CentOS 6 only. It should work with other flavours of Linux too.

This works with any number of IP addresses assigned by your host as long as your server is configured to know they exist ;)

* nat.sh init [external network name] [internal network name] 

These will open and close ports from one network address externally to one internally:

* nat.sh open [WAN IP] [LAN IP] [protocol] [port]
* nat.sh close [WAN IP] [LAN IP] [protocol] [port]

This will create a one to one NAT from an address externally to an address internally:

* nat.sh one-to-one [WAN IP] [LAN IP]

Examples
=======

* nat.sh init eth0 eth1
* nat.sh open 1.2.3.4 192.168.0.5 TCP 80
* nat.sh close 1.2.3.4 192.168.0.5 TCP 80
* nat.sh one-to-one 1.2.3.4 192.168.0.5
