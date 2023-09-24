#!/bin/bash

wget https://github.com/nintech-studydevsysops/raw/main/System/Prometheus/node_exporter-1.0.1.linux-amd64.tar.gz

# Create User
groupadd -f node_exporter
useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
mkdir /etc/node_exporter
chown node_exporter:node_exporter /etc/node_exporter

# Unpack Node Exporter Binary
tar -xvf node_exporter-1.0.1.linux-amd64.tar.gz
mv node_exporter-1.0.1.linux-amd64 node_exporter-files

# Install Node Exporter
cp node_exporter-files/node_exporter /usr/bin/
chown node_exporter:node_exporter /usr/bin/node_exporter

#Setup Node Exporter Service
cat << EOF > /usr/lib/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Documentation=https://prometheus.io/docs/guides/node-exporter/
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter --web.listen-address=:9100

[Install]
WantedBy=multi-user.target
EOF

chmod 664 /usr/lib/systemd/system/node_exporter.service
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter.service
systemctl status node_exporter


echo "Please check firewall and open port 9100"
echo "http://$(hostname -I):9100/metrics"