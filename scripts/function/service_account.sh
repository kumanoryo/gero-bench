#!/bin/sh

set -u

trap 'set_current_account; revoke_service_account; rm -f ${CURRENT_ACCOUNT_TMP}' EXIT

CURRENT_ACCOUNT_TMP=$(mktemp "_$(basename "$0")_current_account")

set_service_account() {
  echo_info "# Get current account."
  gcloud config list --format='value(core.account)' 1>"${CURRENT_ACCOUNT_TMP}"

  echo_info "# Set service account."
  run gcloud auth activate-service-account "${SERVICE_ACCOUNT}" --key-file "${ACCOUNT_FILE}" || return 1;
  return 0
}

revoke_service_account() {
  echo_info "# Revoke service account: ${SERVICE_ACCOUNT}"
  run gcloud auth revoke "${SERVICE_ACCOUNT}"
  return 0
}

set_current_account() {
  current_account=$(cat "${CURRENT_ACCOUNT_TMP}")
  if [ -n "${current_account}" ]; then
    echo_info "# Set current account: ${current_account}"
    run gcloud config set core/account "${current_account}"
  fi
  return 0
}
