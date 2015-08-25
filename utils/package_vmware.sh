# These file shows commands and notes that illustrate the how to package a VMware
# VMs. This has to be done manually as Vagrant does not package VMware VMs
# automatically.
#
# There are various set of commands below for packaging VMs in the default
# VMware Fusion location, and for packaging VMs that have been up'ed.

# General defaults
export VM_DEFAULT_DIR="~/Documents/Virtual\ Machines"
alias vmware-vdiskmanager="/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager"

# These settings are for packaging a base Ubuntu image
export VM_NAME=Ubuntu-14.04LTS-Vagrant-VMware
export VM_DISK_NAME="Virtual Disk-cl1"
export BOX_NAME=ubuntu-vmware

# The generic packaging script
cd "$VM_DEFAULT_DIR/$VM_NAME.vmwarevm"
echo "{\"provider\": \"vmware_desktop\"}" > metadata.json
vmware-vdiskmanager -d "$VM_DISK_NAME.vmdk"
vmware-vdiskmanager -k "$VM_DISK_NAME.vmdk"
rm *.plist
rm *.log
rm -rf *.lck
tar cvzf ${BOX_NAME}.box ./*
mv ${BOX_NAME}.box ~/Downloads

# Having packaged the box, and moved it to downloads, it needs to be added as a
# local box for testing.
cd ~/Downloads
vagrant box add --force --name ${BOX_NAME} ${BOX_NAME}.box 

# Remove any traces of a previous box.
# Remember to change Vagrantfile to point to local box.
cd ~/git/uned-sdn-dev-vm/vmware/
rm -rf .vagrant
vagrant up --provider=vmware_fusion

#https://brianfisher.name/content/reinstall-vmware-tools-vagrant-vmware-fusion-virtual-machine-command-line
