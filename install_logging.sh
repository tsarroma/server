#!/bin/sh

#install java
yum -y install java-openjdk-devel java-openjdk

#tuning java
echo "-Xms1g
-Xmx1g" > /etc/elasticsearch/jvm.options.d/jvm.options

#ELK install
cd /tmp

#Download distr
sshpass -p "qwe123QWE" scp -P 2222 -r root@10.77.197.2:/home/sftp/*.rpm /tmp

#Install distr
rpm -i *.rpm

systemctl daemon-reload

rsync -arvuP /tmp/server/etc/elasticsearch/jvm.options.d/jvm.options /etc/elasticsearch/jvm.options.d/

rsync -arvuP /tmp/server/etc/kibana/kibana.yml /etc/kibana/

yes | cp -f /tmp/server/etc/logstash/logstash.yml /etc/logstash/logstash.yml

rsync -arvuP /tmp/server/etc/logstash/conf.d/logstash-nginx-es.conf /etc/logstash/conf.d/

rsync -arvuP /tmp/server/etc/filebeat/filebeat.yml /etc/filebeat/

chmod go-w /etc/filebeat/filebeat.yml

systemctl enable --now elasticsearch.service
systemctl enable --now kibana
systemctl enable --now logstash
systemctl enable --now filebeat


#Check services
echo "elasticsearch.service"
systemctl is-active elasticsearch.service

echo "kibana"
systemctl is-active kibana

echo "logstash"
systemctl is-active logstash

echo "filebeat"
systemctl is-active filebeat

ss -tlpn
