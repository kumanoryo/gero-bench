#!/bin/sh

set -u -e

QUEUE_BITS_0=$(cat /sys/class/net/eth0/queues/rx-0/rps_cpus)
QUEUE_BITS_1=$(echo "${QUEUE_BITS_0}" | sed -e "s/0/1/g")

for x in /sys/class/net/eth0/queues/rx-*; do echo "${QUEUE_BITS_1}" > "${x}"/rps_cpus; done
echo 32768 > /proc/sys/net/core/rps_sock_flow_entries
for x in /sys/class/net/eth0/queues/rx-*; do echo "4096" > "${x}"/rps_flow_cnt; done
