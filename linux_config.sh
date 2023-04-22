#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
# install nginx git
apt-get update
apt-get -y install nginx git

#Clona repo na home e copia app para pasta default
git clone https://github.com/GitJMSeguradora/sysops-teste.git
cp ./sysops-teste/app/* /var/www/html/

# make sure nginx is started
service nginx start
#echo "nameserver 10.1.1.20" >> /etc/resolv.conf
sudo sed -i '/nameserver 127.0.0.53/i \nameserver 10.1.1.20 \' /etc/resolv.conf

reboot