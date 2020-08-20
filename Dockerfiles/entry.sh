#!/bin/sh

echo "starting pd-server"
# start pd, 1 instance
./pd-server \
    --name=pd1 \
    --data-dir=pd1 \
    --client-urls="http://127.0.0.1:2379" \
    --peer-urls="http://127.0.0.1:2380" \
    --initial-cluster="pd1=http://127.0.0.1:2380" \
    --log-file=pd1.log &


echo "starting tikv-server"
# start tikv, 3 instances
./tikv-server \
    --pd-endpoints="127.0.0.1:2379" \
    --addr="127.0.0.1:20160" \
    --data-dir=tikv1 \
    --log-file=tikv1.log &

./tikv-server \
    --pd-endpoints="127.0.0.1:2379" \
    --addr="127.0.0.1:20161" \
    --data-dir=tikv2 \
    --log-file=tikv2.log &

./tikv-server \
    --pd-endpoints="127.0.0.1:2379" \
    --addr="127.0.0.1:20162" \
    --data-dir=tikv3 \
    --log-file=tikv3.log &


# start tidb, 1 instance
sleep 3
echo "starting tidb-server"
./tidb-server \
    --store=tikv \
    --path="127.0.0.1:2379" \
    -L info \
    --log-file=tidb1.log &

while true; do sleep 1; done
