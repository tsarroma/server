#!/bin/sh

cd /tmp

#download prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz

#unpack tar.gz
tar xzvf ./prometheus-2.45.0.linux-amd64.tar.gz


#install node exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.1/node_exporter-1.1.1.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
cd node_exporter-*.*-amd64
./node_exporter
curl http://localhost:9100/metrics

#install grafana
sudo yum install -y https://dl.grafana.com/oss/release/grafana-10.0.2-1.x86_64.rpm
