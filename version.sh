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
# Docker scan plugin (Hard-coded to avoid "version number does not start with digit" error)
DOCKER_SCAN_REF=v0.8.0
# RPM/DEB specs for Docker (Hard-coded because we have patches)
DOCKER_CE_PACKAGING_REF=409ab6ccdcfb4a32d296d5bee23697cfbd114273
EOF

echo "Wrote _VERSION"
set -x
cat _VERSION
