#!/bin/sh

cd /tmp

mkdir prometheus

#download prometheus and node_exporter
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

#unpack packets
tar xzvf ./prometheus-2.45.0.linux-amd64.tar.gz
tar xzvf ./node_exporter-1.6.1.linux-amd64.tar.gz

#Create user
useradd --no-create-home --shell /usr/bin/false prometheus
useradd --no-create-home --shell /usr/sbin/nologin node_exporter

mkdir -m 755 {/etc/,/var/lib/}prometheus

#Copy binaries and configs
cp -v prometheus.yml /etc/prometheus
rsync --chown=prometheus:prometheus -arvP consoles console_libraries /etc/prometheus
rsync --chown=prometheus:prometheus -arvuP prometheus promtool /usr/local/bin/

#node_exporter copy
rsync --chown=node_exporter:node_exporter -arvuP node_exporter /usr/local/bin/

#Rights set
chown -v -R prometheus: /etc/prometheus
chown -v -R prometheus: /var/lib/prometheus

#Create services
cd /tmp/server
rsync -arvuP node_exporter.service prometheus.service /etc/systemd/system
systemctl daemon-reload

#Start and check services
systemctl enable --now prometheus.service
echo "prometheus.service"
systemctl is-active prometheus.service
systemctl enable --now node_exporter.service
echo "node_exporter.service"
systemctl is-active node_exporter.service



sudo -u prometheus /usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus --web.console.templates /etc/prometheus/consoles --web.console.libraries /etc/prometheus/console_libraries


cd node_exporter-*.*-amd64


./node_exporter


curl http://localhost:9100/metrics



#install grafana
sudo yum install -y https://dl.grafana.com/oss/release/grafana-10.0.2-1.x86_64.rpm
