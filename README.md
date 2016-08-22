# Velocity 2016 Snap Demo

## Setup

### System Requirements

Install:

* Vagrant (>= 1.8.4)
* Virtualbox or Parallels

### Snap Binary

By default the system uses the snap package in the {repo}/pkg directory. The ubuntu packages are available on [packagecloud.io](https://packagecloud.io/intelsdi-x/snap):

```
$ curl -sfL https://packagecloud.io/intelsdi-x/snap/packages/ubuntu/xenial/snap-telemetry_0.15.0-1xenial_amd64.deb/download -o pkg/snap-telemetry_0.15.0-1xenial_amd64.deb
```

Optional: if you want a latest snapd/snapctl place the files in the {repo}/bin directory

```
$ curl -sfL http://snap.ci.snap-telemetry.io/snap/master/latest/snapd -o bin/snapd
$ curl -sfL http://snap.ci.snap-telemetry.io/snap/master/latest/snapctl -o bin/snapctl
```

Download and extract snap plugins into {repo}/plugins directory.

```
$ cd plugins
$ curl -sfLO https://github.com/intelsdi-x/snap/releases/download/v0.15.0-beta/snap-plugins-v0.15.0-beta-linux-amd64.tar.gz
$ tar xvf snap-plugins-v0.15.0-beta-linux-amd64.tar.gz
x snap-v0.15.0-beta/
x snap-v0.15.0-beta/plugin/
x snap-v0.15.0-beta/plugin/snap-plugin-collector-apache
x snap-v0.15.0-beta/plugin/snap-plugin-collector-ceph
x snap-v0.15.0-beta/plugin/snap-plugin-collector-cinder
x snap-v0.15.0-beta/plugin/snap-plugin-collector-cpu
```

### Vagrant VMs

By default only two VMs are configured:
```bash
$ vagrant status
grafana                   running (virtualbox)
snap1                     running (virtualbox)
$ vagrant up
```

To use multiple snap VMs:
```bash
$ export SNAP_DEMO_VMS=5
$ vagrant status
Current machine states:

grafana                   running (virtualbox)
snap1                     running (virtualbox)
snap2                     not created (virtualbox)
snap3                     not created (virtualbox)
snap4                     not created (virtualbox)
snap5                     not created (virtualbox)
$ vagrant up snap{1,2,3,4,5}
```

Additional snap VMs will automatically join a tribe using snap1 as the seed.

### Grafana

To enable grafana, run:

```
$ vagrant ssh grafana -C '(cd /vagrant/influxdb-grfanana && ./initialize.sh)'
```

After the initialization, grafana is available at [http://localhost:3000/](http://localhost:3000)
