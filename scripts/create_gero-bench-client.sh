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

echo_info "# Create Instance Group."
run gcloud deployment-manager deployments create "${INSTANCE_GROUP}" --config "${DM_DIR}"/instance-group.py --properties bucket_name="${BUCKET_NAME}",machineType="${CLIENT_MACHINE_TYPE}",source="${IMAGE_NAME}",network="${NETWORK}",zone="${ZONE}",baseInstanceName="${BASE_INSTANCE_NAME}",instanceTemplate="${INSTANCE_TEMPLATE}",instanceGroupManager="${INSTANCE_GROUP_MANAGER}" || { gcloud deployment-manager deployments delete "${INSTANCE_GROUP}" --quiet; exit 1; }

echo_end_script

exit 0
