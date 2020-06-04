#!/bin/bash
set -eux -o pipefail

# https://github.com/moby/moby/pull/41067
: ${MOBY_REPO=https://github.com/AkihiroSuda/docker.git}
: ${MOBY_COMMIT=f758d598c5170036fd230cadbabbf7f558114f67}
: ${CONTAINERD_COMMIT=master}
: ${RUNC_COMMIT=master}
: ${DOCKER_CLI_REPO=https://github.com/docker/cli.git}
: ${DOCKER_CLI_COMMIT=master}

rm -rf $(cat .gitignore) || sudo rm -rf $(cat .gitignore)
mkdir -p _gopath/src/github.com/docker _artifact/bin
export DOCKER_BUILDKIT=1
export GOPATH="$(pwd)/_gopath"
artifact="$(pwd)/_artifact"

cat <<EOF >$artifact/VERSION.md
# $(date --rfc-3339=date --utc)
EOF

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
git clone $MOBY_REPO $GOPATH/src/github.com/docker/docker
(
	cd $GOPATH/src/github.com/docker/docker
	git checkout $MOBY_COMMIT
	DOCKER_BUILD_ARGS="--build-arg CONTAINERD_COMMIT=$CONTAINERD_COMMIT --build-arg RUNC_COMMIT=$RUNC_COMMIT" \
		make binary
	DOCKER_MAKE_INSTALL_PREFIX=$artifact make install
	for f in dockerd containerd runc rootlesskit vpnkit; do
		cat <<EOF >>$artifact/VERSION.md
## $f
\`\`\`
$($artifact/bin/$f --version)
\`\`\`
EOF
	done
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
git clone $DOCKER_CLI_REPO $GOPATH/src/github.com/docker/cli
(
	cd $GOPATH/src/github.com/docker/cli
	git checkout $DOCKER_CLI_COMMIT
	make -f docker.Makefile binary
	cp -Lf build/docker-linux-amd64 $artifact/bin/docker
	cat <<EOF >>$artifact/VERSION.md
## docker
\`\`\`
$($artifact/bin/docker --version)
\`\`\`
EOF
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

tar --transform="s@^_artifact@moby-snapshot@" --show-transformed-names --owner=nobody --group=nobody --sort=name -cjvf moby-snapshot.tbz _artifact
