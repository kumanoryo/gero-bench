#!/bin/sh
# shellcheck disable=SC1091

set -u

SCRIPTS_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./initializing.sh
. "${SCRIPTS_DIR}/function/initializing.sh"

echo_begin_script

run gcloud deployment-manager deployments create "${BUCKET_NAME}" \
--config deployment-manager/bucket.py \
--properties \
location="${REGION}",storageClass="${BUCKET_CLASS}"

echo_end_script

exit 0
