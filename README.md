# Velocity 2016 Snap Demo

## Setup

### System Requirements

Install:

* Vagrant (>= 1.8.4)
* Virtualbox or Parallels

### Snap Binary

By default the system uses the snap package in the pkg directory. If you want a custom snapd/snapctl place the files in the /bin directory. Download and extract snap plugins into /plugins directory.

### Vagrant VMs

By default only two VMs are configured:
```bash
$ vagrant up grafana
$ vagrant up snap1
```

To use multiple snap VMs:
```
$ export SNAP_DEMO_VMS=5
$ vagrant up snap{1,2,3,4,5}
```

Additional snap VMs will automatically join a tribe using snap1 as the seed.
