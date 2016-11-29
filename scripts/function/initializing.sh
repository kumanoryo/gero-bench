#!/bin/sh
# shellcheck disable=SC1091

set -u

# shellcheck disable=SC2034
PROJECT_ID=$(gcloud config list --format='value(core.project)') || { echo_abort; exit 1; }

# shellcheck source=./common.conf
. "${SCRIPTS_DIR}/conf/common.conf"
# shellcheck source=./echo_custom.sh
. "${SCRIPTS_DIR}/function/echo_custom.sh"
