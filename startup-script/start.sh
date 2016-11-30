#!/bin/sh

set -u -e

QUEUE_BITS_0=$(cat /sys/class/net/eth0/queues/rx-0/rps_cpus)
QUEUE_BITS_1=$(echo "${QUEUE_BITS_0}" | sed -e "s/0/1/g")

for x in /sys/class/net/eth0/queues/rx-*; do echo "${QUEUE_BITS_1}" > "${x}"/rps_cpus; done
echo 32768 > /proc/sys/net/core/rps_sock_flow_entries
for x in /sys/class/net/eth0/queues/rx-*; do echo "4096" > "${x}"/rps_flow_cnt; done

# example: execute sysbench script.
#MYSQL_IP=127.0.0.1
#sh /srv/sysbench/read-heavy.sh -h "${MYSQL_IP}"

# example: execute apache bench command, and send result to GCS bucket.
#PROJECT_ID=$(curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/project/project-id")
#RESULT_FILE="ab_$(date +%Y%m%d-%H%M)_$(hostname).log"
#BUCKET_NAME="${PROJECT_ID}-gero-bench"
#ab -n 100 -c 100 http://www.example.co.jp/ > "${RESULT_FILE}"
#gsutil cp /tmp/"${RESULT_FILE}" "gs://${BUCKET_NAME}/logs/${RESULT_FILE}"
