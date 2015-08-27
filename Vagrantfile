# coding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# This Vagrantfile creates a VM with the odldev user and a toolset for ODL development.

# If you are using the virtualbox provider, install this plugin.
# see http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/
# vagrant plugin install vagrant-vbguest

# Workaround for mitchellh/vagrant#1867
if ARGV[1] and \
   (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
  provider = (ARGV[1].split('=')[1] || ARGV[2])
else
  provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
end
puts "The provider workaround detected #{provider}"

Vagrant.configure(2) do |config|
  if provider == "vmware_fusion"
    # Use the box in the Atlas catalogue
    config.vm.box = "matuteana/ubuntu-vmware"
    # Or a local box
    # config.vm.box = "ubuntu-vmware"
  end

  if provider == "virtualbox"
    # Use the box in the Atlas catalogue
    config.vm.box = "matuteana/ubuntu-vbox"
    # Or a local box
    # config.vm.box = "ubuntu-vbox"
  end
    
  config.vm.hostname = "odldevvm"
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # Look out for this issue https://github.com/mitchellh/vagrant/issues/3083
  config.vm.network "private_network", type: "dhcp"
  
  # Configuring VMware
    if provider == "vmware_fusion"
      config.vm.provider "vmware_fusion" do |vmw|
        # Display the GUI when booting the machine
        vmw.gui = true
        # Customize the amount of memory and CPUs on the VM:
        vmw.vmx["memsize"] = "6144"
        vmw.vmx["numvcpus"] = "4"
      end
    end

  # Configuring VBox
  if provider =="virtualbox"
    config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = true
      # Customize the amount of memory on the VM:
      vb.memory = "6144"
      vb.cpus = 4
      # Enable the shared clipboard:
      vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    end
  end

  # Update software, set up users
  # Installing mininet first is important because of dependencies
  config.vm.provision "shell", path: "scripts/build/install_mininet.sh"

  # Update base OS packages
  config.vm.provision "shell", path: "scripts/build/apt-get_update.sh"

  # The cloud-init install is only required for VMs targetted to be used within VIRL
  # config.vm.provision "shell", path: "scripts/build/cloud_init.sh"

  # Update vmware tools or vbox guest additions after the (possible) kernel update during the
  # apt-get_update stage above.
  if provider == "vmware_fusion"
    config.vm.provision "shell", path: "scripts/build/reconfigure_vmware_tools.sh"
  end
  # This is still problematic as the rebuld will be against headers for the running kernel,
  # which fails, so need to revisit and rework, update guest additions manually meanwhile. TODO
  # if provider == "virtualbox"
  #  config.vm.provision "shell", path: "scripts/build/update_vbox_guest_additions.sh"
  # end  

  # https://bugs.launchpad.net/ubuntu/+source/indicator-keyboard/+bug/1302136
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get install libgnomekbd-common -y
  SHELL
  
  # Tidy up after updating base OS packages
  config.vm.provision "shell", path: "scripts/build/apt-get_clean.sh"

  # Add the odeldev user
  config.vm.provision "shell", path: "scripts/build/add_odldev_user.sh"
  
  # Change the login screen to require explicit user name entry for better security (optional)
  config.vm.provision "shell", path: "scripts/build/hide_login_users.sh"

  # Install tools and software
  config.vm.provision "shell", path: "scripts/build/install_chrome.sh"
  config.vm.provision "shell", path: "scripts/build/install_java.sh"
  config.vm.provision "shell", path: "scripts/build/install_pip.sh"
  config.vm.provision "shell", path: "scripts/build/install_eclipse.sh"
  config.vm.provision "shell", path: "scripts/build/install_intellij.sh"
  config.vm.provision "shell", path: "scripts/build/install_pycharm.sh"
  config.vm.provision "shell", path: "scripts/build/install_wireshark.sh"
  config.vm.provision "shell", path: "scripts/build/install_maven.sh"
  config.vm.provision "shell", path: "scripts/build/install_git.sh"

  # Create the target directories for the file provisioning below
  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p ~vagrant/bin
    chown vagrant ~vagrant/bin
    mkdir -p ~vagrant/Desktop
    chown vagrant ~vagrant/Desktop
  SHELL

  # This two step approach to copying files from the host seems sub-optimal
  # but it is all that seems to work for now, see
  # http://serverfault.com/questions/565281/how-to-upload-configuration-files-using-the-shell-provider
  # and http://stackoverflow.com/questions/25516462/how-can-i-upload-more-than-one-file-with-vagrant-file-provisioning, which is why there is no wildcarding used below
    config.vm.provision "file", source: "scripts/vm_files/Desktop/Chrome.desktop", destination: "~vagrant/Desktop/Chrome.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Eclipse-JEE.desktop", destination: "~vagrant/Desktop/Eclipse-JEE.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/IntelliJ.desktop", destination: "~vagrant/Desktop/IntelliJ.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/PyCharm.desktop", destination: "~vagrant/Desktop/PyCharm.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Terminal.desktop", destination: "~vagrant/Desktop/Terminal.desktop"
  # config.vm.provision "file", source: "scripts/vm_files/Desktop/VMMaestro.desktop", destination: "~vagrant/Desktop/VMMaestro.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Wireshark.desktop", destination: "~vagrant/Desktop/Wireshark.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Clone_Client_Code.desktop", destination: "~vagrant/Desktop/Clone_Client_Code.desktop"
  config.vm.provision "file", source: "scripts/vm_files/bin/build_controller.sh", destination: "~vagrant/bin/build_controller.sh"
  config.vm.provision "file", source: "scripts/vm_files/bin/build_tutorials.sh", destination: "~vagrant/bin/build_tutorials.sh"
  config.vm.provision "file", source: "scripts/vm_files/bin/clone_client_project.sh", destination: "~vagrant/bin/clone_client_project.sh"
  config.vm.provision "file", source: "scripts/vm_files/bin/start_odl.sh", destination: "~vagrant/bin/start_odl.sh"
  config.vm.provision "file", source: "scripts/vm_files/bin/odl_status.sh", destination: "~vagrant/bin/odl_status.sh"
  config.vm.provision "file", source: "scripts/vm_files/bin/stop_odl.sh", destination: "~vagrant/bin/stop_odl.sh"
			
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Clone_and_Build_ODL.desktop", destination: "~vagrant/Desktop/Clone_and_Build_ODL.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Clone_and_Build_Tutorials.desktop", destination: "~vagrant/Desktop/Clone_and_Build_Tutorials.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/README.md", destination: "~vagrant/Desktop/README.md"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Using_Chrome.md", destination: "~vagrant/Desktop/Using_Chrome.md"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/ODL_and_Mininet.md", destination: "~vagrant/Desktop/ODL_and_Mininet.md"
    config.vm.provision "file", source: "scripts/vm_files/Desktop/ODL_and_VIRL.md", destination: "~vagrant/Desktop/ODL_and_VIRL.md"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Stop_ODL.desktop", destination: "~vagrant/Desktop/Stop_ODL.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/ODL_Status.desktop", destination: "~vagrant/Desktop/ODL_Status.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/Start_ODL.desktop", destination: "~vagrant/Desktop/Start_ODL.desktop"
  config.vm.provision "file", source: "scripts/vm_files/Desktop/odl.cfg", destination: "~vagrant/Desktop/odl.cfg"
  config.vm.provision "file", source: "scripts/vm_files/Chrome_Bookmarks", destination: "~vagrant/Chrome_Bookmarks"

  # Move provisioned files into position
  config.vm.provision "shell", path: "scripts/build/move_permissions_desktop_bin.sh"

  # Add required environment variables
  config.vm.provision "shell", path: "scripts/build/bashrc_variables.sh"

  config.vm.provision "shell", inline: <<-SHELL
  # Tidy up bash history
  cat /dev/null > ~/.bash_history && history -c
  SHELL

  # Do this last so that we still have a vagrant user for debug purposes in case anything above fails
  # Delete the target directories for the file provisioning above
  config.vm.provision "shell", inline: <<-SHELL
    rm -rf ~vagrant/bin
    rm -rf ~vagrant/Desktop
  SHELL
  # Disable vagrant user for security purposes
  config.vm.provision "shell", path: "scripts/build/disable_vagrant_user.sh"

  # Clean up logs to save space
  config.vm.provision "shell", path: "scripts/build/cleanup_logs.sh"

  # Zero out disk to actually claim back any space saved
  config.vm.provision "shell", path: "scripts/build/zero_disk.sh"
end
