#!/bin/bash

set -e

echo "checking git repos"
if [ ! -d pd ]; then
    git clone https://github.com/pingcap/pd.git
fi
if [ ! -d tikv ]; then
    git clone https://github.com/tikv/tikv.git
fi
if [ ! -d tidb ]; then
    git clone https://github.com/pingcap/tidb.git
fi

echo "docker build"
# --network & --build-arg lines are for network issues, please smodify as you like
docker build . -f run/Dockerfile \
    # --network host \
    # --build-arg HTTP_PROXY=http://127.0.0.1:7890 \
    # --build-arg HTTPS_PROXY=https://127.0.0.1:7890 \
    # --build-arg http_proxy=http://127.0.0.1:7890 \
    # --build-arg https_proxy=https://127.0.0.1:7890 \
    -t tidb-cluster

echo "docker run"
docker run -it --rm tidb-cluster /bin/bash