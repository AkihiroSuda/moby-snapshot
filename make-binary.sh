#!/bin/bash
set -eux -o pipefail

if [[ ! -f _VERSION ]]; then
	echo "Run version.sh first"
	exit 1
fi
source _VERSION

export DOCKER_BUILDKIT=1
artifact="$(pwd)/_artifact/moby-snapshot-$(uname -m)"
mkdir -p _gopath/src/github.com/docker ${artifact}/bin
export GOPATH="$(pwd)/_gopath"

set +x
cat <<EOF
 __  __       _           
|  \/  | ___ | |__  _   _ 
| |\/| |/ _ \| '_ \| | | |
| |  | | (_) | |_) | |_| |
|_|  |_|\___/|_.__/ \__, |
                    |___/ 
EOF
set -x
git clone https://github.com/moby/moby.git $GOPATH/src/github.com/docker/docker
(
	cd $GOPATH/src/github.com/docker/docker
	git checkout $DOCKER_ENGINE_REF
	DOCKER_BUILD_ARGS="--build-arg CONTAINERD_COMMIT=$CONTAINERD_REF --build-arg RUNC_COMMIT=$RUNC_REF" \
		make binary
	DOCKER_MAKE_INSTALL_PREFIX=$artifact make install
)

set +x
cat <<EOF
 ____             _                ____ _     ___ 
|  _ \  ___   ___| | _____ _ __   / ___| |   |_ _|
| | | |/ _ \ / __| |/ / _ \ '__| | |   | |    | | 
| |_| | (_) | (__|   <  __/ |    | |___| |___ | | 
|____/ \___/ \___|_|\_\___|_|     \____|_____|___|
                                                  
EOF
set -x
git clone https://github.com/docker/cli.git $GOPATH/src/github.com/docker/cli
(
	cd $GOPATH/src/github.com/docker/cli
	git checkout $DOCKER_CLI_REF
	make -f docker.Makefile binary
	cp -Lf build/docker-linux-amd64 $artifact/bin/docker
)

set +x
cat <<EOF
 ____                   
|  _ \  ___  _ __   ___ 
| | | |/ _ \| '_ \ / _ \
| |_| | (_) | | | |  __/
|____/ \___/|_| |_|\___|
                        
EOF
set -x

(
	cd _artifact
	tar --owner=nobody --group=nobody --sort=name -cjvf ../moby-snapshot-$(uname -m).tbz moby-snapshot-$(uname -m)
)
