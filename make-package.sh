#!/bin/bash
set -eu -o pipefail

if [[ $# != 2 ]]; then
	echo "Usage: $0 DISTRO VERSION"
	exit 1
fi

distro="$1"
version="$2"

type="deb"
case "$distro" in
*centos* | *rhel* | *fedora*)
	type="rpm"
	;;
esac

base=$(pwd)
artifact="${base}/_artifact-${distro}-${version}-$(uname -m)-${type}"

if [[ ! -f _VERSION ]]; then
	echo "Run version.sh first"
	exit 1
fi
source _VERSION

mkdir -p $artifact _gopath/src/github.com/docker
(
	cd _gopath/src/github.com/docker
	git clone https://github.com/docker/docker-ce-packaging.git
	(
		cd docker-ce-packaging
    git checkout $DOCKER_CE_PACKAGING_REF
		for f in $base/patches/docker-ce-packaging/*.patch; do
			patch -p1 <$f
		done
		make DOCKER_ENGINE_REF=$DOCKER_ENGINE_REF DOCKER_CLI_REF=$DOCKER_CLI_REF PLATFORM="Moby Engine" checkout
		make -C $type DOCKER_ENGINE_REF=$DOCKER_ENGINE_REF DOCKER_CLI_REF=$DOCKER_CLI_REF PLATFORM="Moby Engine" "${distro}-${version}"
		if [[ "$type" = "rpm" ]]; then
			mv rpm/rpmbuild/RPMS/$(uname -m)/*.rpm $artifact
		else
			mv deb/debbuild/${distro}-${version}/*.deb $artifact
		fi
	)

	git clone https://github.com/docker/containerd-packaging.git
	(
		cd containerd-packaging
		git checkout $CONTAINERD_PACKAGING_REF
		make RUNC_REF=$RUNC_REF REF=$CONTAINERD_REF "docker.io/library/${distro}:${version}"
		if [[ "$type" = "rpm" ]]; then
			mv $(ls -1 build/${distro}/${version}/$(uname -m)/*.rpm | grep -v '\.src\.rpm$') $artifact
		else
			debarch=$(uname -m | sed -e s/x86_64/amd64/)
			mv build/${distro}/${version}/${debarch}/*.deb $artifact
		fi
	)
)

(
	cd $artifact
	tar --owner=nobody --group=nobody --sort=name -cjvf ../moby-snapshot-${distro}-${version}-$(uname -m)-${type}.tbz *
)
