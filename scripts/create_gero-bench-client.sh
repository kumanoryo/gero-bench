#!/bin/sh
# shellcheck disable=SC1091

set -u

SCRIPTS_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./initializing.sh
. "${SCRIPTS_DIR}/function/initializing.sh"

HOME_DIR=$(cd "$(dirname "$0")"/..;pwd) || exit 1
DM_DIR="${HOME_DIR}/deployment-manager"
STARTUP_SCRIPT_DIR="${HOME_DIR}/startup-script"

echo_begin_script

echo_info "# Upload startup-script."
run gsutil cp "${STARTUP_SCRIPT_DIR}"/start.sh gs://"${BUCKET_NAME}"/startup-script/start.sh || { echo_abort; exit 1; }

echo_info "# Create Instance Template."
run gcloud deployment-manager deployments create "${INSTANCE_TEMPLATE}" --config "${DM_DIR}"/instance-template.py --properties bucket_name="${BUCKET_NAME}",machineType="${CLIENT_MACHINE_TYPE}",source="${IMAGE_NAME}",network="${NETWORK}" || { gcloud deployment-manager deployments delete "${INSTANCE_TEMPLATE}" --quiet; exit 1; }

echo_info "# Create Instance Group Manager."
run gcloud deployment-manager deployments create "${INSTANCE_GROUP_MANAGER}" --config "${DM_DIR}"/instance-group-manager.py --properties zone="${ZONE}",baseInstanceName="${BASE_INSTANCE_NAME}",instanceTemplate="${INSTANCE_TEMPLATE}" || { gcloud deployment-manager deployments delete "${INSTANCE_GROUP_MANAGER}" --quiet; exit 1; }

echo_end_script

exit 0
