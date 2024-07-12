#!/bin/sh
# Launch dockerd
echo "Launching dockerd"
nohup dockerd-entrypoint.sh &

echo "Sleeping for 10 seconds to allow dockerd to start"
sleep 10
export DOCKER_CERT_PATH=/certs/server/

# Create Kind cluster
kind create cluster --wait 5m --config=/etc/kind/config.yaml

echo "127.0.0.1 kubernetes" >> /etc/hosts
sed -i 's/0.0.0.0/kubernetes/g' /root/.kube/config
chmod a+r -R /root/.kube

# Sleep indefinitely
sleep infinity
