#!/bin/sh

set -u

RUN_TMP=$(mktemp "_$(basename "$0").XXXXXX")

red=31
green=32

trap 'rm -f ${RUN_TMP}' EXIT

colored() {
  color=$1
  shift
  echo "\033[${color}m$*\033[m"
}

run() {
  "$@" 1>"${RUN_TMP}" 2>&1
  result=$?

  if [ $result -eq 0 ]; then
    colored $green "Succeeded:" "$@"
  else
    colored $red "$(cat "${RUN_TMP}")"
    colored $red "Failed:" "$@"
  fi

  rm -f "${RUN_TMP}"

  return "${result}"
}

echo_begin_script() {
  colored $green "*****************************"
  colored $green "Start $(basename "$0")"
  colored $green "*****************************"
}

echo_end_script() {
  colored $green "*****************************"
  colored $green "End $(basename "$0")"
  colored $green "*****************************"
}

echo_abort() {
  colored $red "Abort $(basename "$0")"
}

echo_info() {
  colored $green "$@"
}

echo_error() {
  colored $red "$@"
}
