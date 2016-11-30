#!/bin/sh

set -e

cd /src/sysbench
bzr branch lp:sysbench
cd sysbench
./autogen.sh
./configure
make
mkdir -p /srv/sysbench/src
cp -r sysbench /srv/sysbench/src/
