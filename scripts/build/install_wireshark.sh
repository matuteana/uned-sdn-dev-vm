#!/bin/bash
#The latest version with OpenFlow support is 1.12.x which needs a repository added. See:
#http://linuxg.net/how-to-install-wireshark-1-12-4-on-ubuntu-15-04-ubuntu-14-10-ubuntu-14-04-ubuntu-12-04-and-derivative-systems-via-ppa/
add-apt-repository ppa:pi-rho/security -y
apt-get update -y
apt-get install wireshark wireshark-doc -y

#Then set up groups and permissions so that the odldev user can listen on all interfaces and ports

groupadd --system wireshark
usermod -a -G wireshark odldev
chgrp wireshark /usr/bin/dumpcap
chmod 750 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
