#!/bin/bash

sudo apt-get update && sudo apt-get install -y wget unzip

sudo mkdir -p /opt/consul/data
sudo mkdir -p /opt/consul/config

cd /opt/consul
sudo wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip
sudo unzip consul_0.6.4_linux_amd64.zip
sudo chmod 755 consul

cd /opt/consul/config-dir
sudo wget https://raw.githubusercontent.com/Collabco/consul-on-ubuntu-existing-vnet/master/config.json

atlas=$(echo "$1" | sed 's/\//\\\//g')
sudo sed -i 's/{{ATLAS_INFRASTRUCTURE}}/'"$atlas"'/' config.json
sudo sed -i 's/{{ATLAS_TOKEN}}/'"$2"'/' config.json
sudo sed -i 's/{{DC_NAME}}/'"$3"'/' config.json
sudo sed -i 's/{{ENCRYPT_KEY}}/'"$4"'/' config.json

cd /opt/consul
sudo nohup ./consul agent -config-dir="/opt/consul/config" &
