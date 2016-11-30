#!/bin/sh

set -u

SYSBENCH_DIR="/srv/sysbench/src/sysbench"

CMDNAME=$(basename "$0")
USAGE="Usage: ${CMDNAME} -h HOST [-u USER] [-p PASSWORD] [-d DATABASE]"


while getopts h:u:p:d: OPT
do
  case $OPT in
    "h" ) VALUE_HOST="$OPTARG" ;;
    "u" ) VALUE_USER="$OPTARG" ;;
    "p" ) VALUE_PASSWORD="$OPTARG" ;;
    "d" ) VALUE_DATABASE="$OPTARG" ;;
      * ) echo "${USAGE}" 1>&2
          exit 1 ;;
  esac
done

if [ -z "${VALUE_HOST}" ]; then
  echo "${USAGE}"
  exit 1
fi

MYSQL_IP="${VALUE_HOST}"
SYSBENCH_USER="${VALUE_USER:-sysbench}"
SYSBENCH_PASSWORD="${VALUE_PASSWORD:-sysbench}"
SYSBENCH_DB="${VALUE_DATABASE:-sbtest}"

mysql -uroot -h"${MYSQL_IP}" -e "CREATE DATABASE IF NOT EXISTS ${SYSBENCH_DB}"
mysql -uroot -h"${MYSQL_IP}" -e "GRANT ALL ON ${SYSBENCH_DB}.* TO '${SYSBENCH_USER}'@'%' IDENTIFIED BY '${SYSBENCH_PASSWORD}'"

cd "${SYSBENCH_DIR}" && \
./sysbench \
	--test=tests/db/oltp.lua \
	--mysql-host="${MYSQL_IP}" \
	--mysql-port=3306 \
	--mysql-user="${SYSBENCH_USER}" \
	--mysql-password="${SYSBENCH_PASSWORD}" \
	--mysql-db="${SYSBENCH_DB}" \
	--mysql-table-engine=innodb \
	--oltp-table-size=25000 \
	--oltp-tables-count=250 \
	--db-driver=mysql \
	prepare
