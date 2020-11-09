# Binary snapshots of [Moby](https://github.com/moby/moby)

Binary snapshots of [Moby](https://github.com/moby/moby) with containerd and runc.
Irregularly updated.

## Download
[Here](https://github.com/AkihiroSuda/moby-snapshot/releases)

## Usage

### Static binaries
```console
$ tar xjvf moby-snapshot-x86_64.tbz
moby-snapshot-x86_64/
moby-snapshot-x86_64/bin/
moby-snapshot-x86_64/bin/containerd
moby-snapshot-x86_64/bin/containerd-shim
moby-snapshot-x86_64/bin/containerd-shim-runc-v2
moby-snapshot-x86_64/bin/ctr
moby-snapshot-x86_64/bin/docker
moby-snapshot-x86_64/bin/docker-init
moby-snapshot-x86_64/bin/docker-proxy
moby-snapshot-x86_64/bin/dockerd
moby-snapshot-x86_64/bin/dockerd-rootless-setuptool.sh
moby-snapshot-x86_64/bin/dockerd-rootless.sh
moby-snapshot-x86_64/bin/rootlesskit
moby-snapshot-x86_64/bin/rootlesskit-docker-proxy
moby-snapshot-x86_64/bin/runc
moby-snapshot-x86_64/bin/vpnkit
$ sudo cp ./moby-snapshot-x86_64/bin/* /usr/local/bin
$ sudo dockerd
```

### deb
- Ubuntu 20.04 (Focal Fossa)
- Ubuntu 20.10 (Groovy Gorilla)

```console
$ tar xjvf moby-snapshot-ubuntu-focal-x86_64-deb.tbz 
containerd.io_0.20200717.014906~4feb8c4-1_amd64.deb
moby-snapshot-cli_0.0.0-20200716165816-bece8cc41c-0~ubuntu-focal_amd64.deb
moby-snapshot-rootless-extras_0.0.0-20200716165816-bece8cc41c-0~ubuntu-focal_amd64.deb
moby-snapshot_0.0.0-20200716165816-bece8cc41c-0~ubuntu-focal_amd64.deb
$ sudo apt-get install ./*.deb
```

### rpm
- CentOS 8
- Fedora 33

```console
$ tar xjvf moby-snapshot-fedora-32-x86_64-rpm.tbz 
containerd.io-0.20200717.014906~4feb8c4-0.fc32.x86_64.rpm
moby-snapshot-0.0.0.20200716165816.bece8cc41c-0.fc32.x86_64.rpm
moby-snapshot-cli-0.0.0.20200716165816.bece8cc41c-0.fc32.x86_64.rpm
moby-snapshot-rootless-extras-0.0.0.20200716165816.bece8cc41c-0.fc32.x86_64.rpm
$ sudo dnf install ./*.rpm
```

Works on cgroup v2 hosts by default.
No need to tweak the `systemd.unified_cgroup_hierarchy` kernel cmdline.
