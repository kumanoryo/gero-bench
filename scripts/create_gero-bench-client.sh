#!/bin/sh
# shellcheck disable=SC1091

set -u

SCRIPTS_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./initializing.sh
. "${SCRIPTS_DIR}/function/initializing.sh"

HOME_DIR=$(cd "$(dirname "$0")"/..;pwd) || exit 1
STARTUP_SCRIPT_DIR="${HOME_DIR}/startup-script"

echo_begin_script

echo_info "# Upload startup-script."
run gsutil cp "${STARTUP_SCRIPT_DIR}"/start.sh gs://"${BUCKET_NAME}"/startup-script/start.sh || { echo_abort; exit 1; }

echo_info "# Create Instance Template."
run gcloud deployment-manager deployments create "${INSTANCE_TEMPLATE}" --config "${DM_DIR}"/instance-template.py --properties bucket_name="${BUCKET_NAME}",machineType="${MACHINE_TYPE}",source="${IMAGE_NAME}",network="${NETWORK}" || { gcloud deployment-manager deployments delete "${INSTANCE_TEMPLATE}" --quiet; exit 1; }

echo_end_script

exit 0
