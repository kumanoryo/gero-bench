#!/bin/sh
# shellcheck disable=SC1091

set -u

SCRIPTS_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./initializing.sh
. "${SCRIPTS_DIR}/function/initializing.sh"

HOME_DIR=$(cd "$(dirname "$0")"/..;pwd) || exit 1
DM_DIR="${HOME_DIR}/deployment-manager"

echo_begin_script

run gcloud deployment-manager deployments create "${BUCKET_NAME}" \
--config "${DM_DIR}"/bucket.py \
--properties \
location="${REGION}",storageClass="${BUCKET_CLASS}"

echo_end_script

exit 0
