#!/bin/sh

mkdir /tmp/prometheus

cd /tmp/prometheus

#download prometheus and node_exporter
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

#unpack packets
tar xzvf /tmp/prometheus/prometheus-2.45.0.linux-amd64.tar.gz 
tar xzvf /tmp/prometheus/node_exporter-1.6.1.linux-amd64.tar.gz
mv /tmp/prometheus/prometheus-2.45.0.linux-amd64 /tmp/prometheus/prometheus
mv /tmp/prometheus/node_exporter-1.6.1.linux-amd64 /tmp/prometheus/node_exporter

#reate user
useradd --no-create-home --shell /usr/bin/false prometheus
useradd --no-create-home --shell /usr/sbin/nologin node_exporter

mkdir -m 755 {/etc/,/var/lib/}prometheus

#Copy binaries and configs
cp -v /tmp/server/etc/prometheus/prometheus.yml /etc/prometheus
cd /tmp/prometheus/prometheus
rsync --chown=prometheus:prometheus -arvuP consoles console_libraries /etc/prometheus
rsync --chown=prometheus:prometheus -arvuP prometheus promtool /usr/local/bin/

#node_exporter copy
cd /tmp/prometheus/node_exporter
rsync --chown=node_exporter:node_exporter -arvuP node_exporter /usr/local/bin/

#Rights set
chown -v -R prometheus: /etc/prometheus
chown -v -R prometheus: /var/lib/prometheus

#Create services
cd /tmp/server/etc/systemd/system/
rsync -arvuP node_exporter.service prometheus.service /etc/systemd/system
systemctl daemon-reload

#install grafana
yum install -y https://dl.grafana.com/oss/release/grafana-10.0.2-1.x86_64.rpm

cd /tmp/server/etc/
rsync -arvuP grafana /etc

#Start and check services
systemctl enable --now prometheus.service
echo "prometheus.service"
systemctl is-active prometheus.service
systemctl enable --now node_exporter.service
echo "node_exporter.service"
systemctl is-active node_exporter.service
systemctl enable --now grafana-server
echo "grafana-server"
systemctl is-active grafana-server

ss -tlpn
