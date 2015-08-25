#!/bin/bash
apt-get install wireshark wireshark-doc -y
groupadd wireshark
usermod -a -G wireshark odldev
chgrp wireshark /usr/bin/dumpcap
chmod 750 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
