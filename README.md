# Binary snapshot of [Moby](https://github.com/moby/moby)

Binary (irregularly updated): https://github.com/AkihiroSuda/moby-snapshot/releases

```console
$ tar xjvf moby-snapshot.tbz
moby-snapshot/
moby-snapshot/VERSION.md
moby-snapshot/bin/
moby-snapshot/bin/containerd
moby-snapshot/bin/containerd-shim
moby-snapshot/bin/containerd-shim-runc-v2
moby-snapshot/bin/ctr
moby-snapshot/bin/docker
moby-snapshot/bin/docker-init
moby-snapshot/bin/docker-proxy
moby-snapshot/bin/dockerd
moby-snapshot/bin/dockerd-rootless-setuptool.sh
moby-snapshot/bin/dockerd-rootless.sh
moby-snapshot/bin/rootlesskit
moby-snapshot/bin/rootlesskit-docker-proxy
moby-snapshot/bin/runc
moby-snapshot/bin/vpnkit
$ sudo cp ./moby-snapshot/bin/* /usr/local/bin
$ sudo dockerd
```
