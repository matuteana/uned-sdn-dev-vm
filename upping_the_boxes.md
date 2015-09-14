#  Installing Vagrant

To "up" a box, you first need to
[install Vagrant](http://docs.vagrantup.com/v2/installation/), and
plugins for VirtualBox and VMware Fusion, all of which
is explained below and illustrated in these videos:

[1 - How to install Vagrant on OS X](https://www.youtube.com/watch?v=n-4PL1DQ7Dg)
[2 - How to install the Vagrant VMware Fusion plugin on OS X](https://www.youtube.com/watch?v=02pcjmNyw1k)
[3 - How to install the Vagrant VirtualBox guest additions plugin on OS X](https://www.youtube.com/watch?v=JFE_9g5iI1Q)

# Upping the Boxes

Given a [Vagrantfile](vagrant_files/Vagrantfile). 

You can do this:

```bash
$ vagrant up --provider=vmware_fusion
```

OR

```bash
$ vagrant up --provider=virtualbox
```

And then waits for ~20 minutes for the Dev VM to be built. Further
details are below.

## The "vagrant up ..." Command

The general form of the command to up a box (given a Vagrantfile in
the current directory) is below. The "provider" argument should be
*one* of `[virtualbox|vmware\_fusion|vmware\_workstation]`, where
`virtualbox` is generic for all platforms that support that provider,
`vmware\_fusion` is for Mac OS X, and `vmware\_workstation` is for
Windows. Note that the provider for a VMWare based box, when adding a box to Atlas, is "vmware_desktop".

The base boxes used here are available in [Atlas](https://atlas.hashicorp.com/matuteana)

Bringing up a box from Atlas would look like this:

```bash
$ vagrant up --provider=virtualbox
The provider workaround detected virtualbox
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'matuteana/ubuntu-vbox' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'matuteana/ubuntu-vbox'
    default: URL: https://atlas.hashicorp.com/matuteana/ubuntu-vbox
==> default: Adding box 'matuteana/ubuntu-vbox' (v0.0.1) for provider: virtualbox
    default: Downloading: https://atlas.hashicorp.com/matuteana/boxes/ubuntu-vbox/versions/0.0.1/providers/virtualbox.box
    default: Progress: 83% (Rate: 8953k/s, Estimated time remaining: 0:00:31)
```

## VirtualBox

Before using the VBox VM, install the [vbguest plugin](https://github.com/dotless-de/vagrant-vbguest), like this:

```bash
vagrant plugin install vagrant-vbguest
Installing the 'vagrant-vbguest' plugin. This can take a few minutes...
Installed the plugin 'vagrant-vbguest (0.10.0)'!
```

## VMware Fusion

To use the VMware Fusion provider, you need to purchase a licence
from here: http://www.vagrantup.com/vmware#buy-now.

Note that an error might occur, in which case you can just try again.


## Destroying the Boxes

The normal form of destroying a box is `vagrant destroy`, but that
does work for the VMWare based boxes because of the technique I have used to support multiple
base boxes described above. See https://github.com/mitchellh/vagrant/issues/3876

The simple workaround is `rm -rf .vagrant` in the same directory as
the `vagrant up` command was used.

# One Vagrantfile for Multiple Providers

This project uses one Vagrantfile for multiple providers, which is
non-trivial to achieve, as discussed in this
[thread.](https://groups.google.com/forum/#!topic/vagrant-up/XIxGdm78s4I). 

Since a Vagrantfile is, in effect, Ruby code, you can write
conditional logic in the Vagrantfile itself. Based on hints from
the thread above, the provided Vagrantfile has a section like this:

``` python
# Workaround for mitchellh/vagrant#1867
if ARGV[1] and \
   (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
  provider = (ARGV[1].split('=')[1] || ARGV[2])
else
  provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
end
puts "The provider workaround detected #{provider}"
```

That means that the `provider` variable can be used later in the
Vagrantfile like this:

```python
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
```

The effect is to be able to differentiate, based on the provider,
which base box to use. The first "config.vm.box" statement uses, and
so would cause to be downloaded, a box from the Atlas catalogue in the
[matuteana project](https://atlas.hashicorp.com/matuteana). The Atlas
Ubuntu boxes are what you would use under normal
circumstances. Regular updates of the base Ubuntu boxes can be published there.

When developing and testing, you would use a local box, which would be
added to Atlas once working.

