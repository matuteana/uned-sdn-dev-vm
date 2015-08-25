#!/bin/bash
# Reconfigure VBox Guest Additions after software update
# see http://askubuntu.com/questions/22743/how-do-i-install-guest-additions-in-a-virtualbox-vm/99479#99479
# We need the headers for the kernal that is actually running
apt-get install build-essential linux-headers-$(uname -r) -y
apt-get install virtualbox-guest-additions-iso -y
mount /usr/share/virtualbox/VBoxGuestAdditions.iso /mnt
/mnt/VBoxLinuxAdditions.run
