#!/bin/bash
set -eux -o pipefail
rm -rf $(cat .gitignore) || sudo rm -rf $(cat .gitignore)
