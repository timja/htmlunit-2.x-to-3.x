#!/usr/bin/env bash

set -eo pipefail

# This script migrates HtmlUnit from 2.x to 3.x
#
# Usage:
#
# Requirements:
# - https://github.com/lindell/multi-gitter
# - A GitHub Personal Access Token in GITHUB_TOKEN env var

if ! [ -x "$(command -v multi-gitter)" ]; then
  echo 'Error: multi-gitter is not installed.' >&2
  exit 1
fi

if [[ -z ${GITHUB_TOKEN} ]]; then
  echo 'Error: the GITHUB_TOKEN env var is not set.' >&2
  exit 2
fi

set -x

multi-gitter run ./replace.sh --config multi-gitter-config.yaml
