#!/bin/bash
set -eu -o pipefail

x() {
	name=$1
	repo=$2
	comment=$3
	sha=$(git ls-remote https://github.com/$repo HEAD | awk '{ print $1}')
	echo "# $comment"
	echo "${name}_REF=${sha}"
}

now=$(LANG=C date --utc)

cat >_VERSION <<EOF
# Fetched on ${now}
#
$(x RUNC opencontainers/runc "runc")
$(x CONTAINERD containerd/containerd "containerd")
$(x DOCKER_ENGINE moby/moby "Docker Engine (Moby)")
$(x DOCKER_CLI docker/cli "Docker CLI")
$(x CONTAINERD_PACKAGING docker/containerd-packaging "RPM/DEB specs for containerd")
# RPM/DEB specs for Docker
DOCKER_CE_PACKAGING_REF=5a7d3cd145182a9f9e9598a9851f793a34c2543f
EOF
# DOCKER_CE_PACKAGING_REF is hard-coded because we have patches

echo "Wrote _VERSION"
set -x
cat _VERSION
