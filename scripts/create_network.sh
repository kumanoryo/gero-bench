#!/bin/sh
# shellcheck disable=SC1091

set -u

SCRIPTS_DIR=$(cd "$(dirname "$0")" && pwd) || exit 1
# shellcheck source=./initializing.sh
. "${SCRIPTS_DIR}/function/initializing.sh"

HOME_DIR=$(cd "$(dirname "$0")"/..;pwd) || exit 1
DM_DIR="${HOME_DIR}/deployment-manager"

echo_begin_script

echo_info "# Create network."
run gcloud deployment-manager deployments create "${NETWORK}" --config "${DM_DIR}"/network.py || { gcloud deployment-manager deployments delete "${NETWORK}" --quiet; exit 1; }

echo_info "# Create firewall rules."
run gcloud deployment-manager deployments create "${FIREWALL}" --config "${DM_DIR}"/firewall.py --properties network="${NETWORK}" || { gcloud deployment-manager deployments delete "${FIREWALL}" --quiet; exit 1; }

echo_end_script

exit 0
