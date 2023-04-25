#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
# Instala nginx git
apt-get update
apt-get -y install nginx git

#Clona repo na home e copia app para pasta default
git clone https://github.com/GitJMSeguradora/sysops-teste.git
cp ./sysops-teste/app/* /var/www/html/

#Cria uma entrada no nginx para gerar estatisticas
cat << 'EOF' | tee /etc/nginx/sites-enabled/nginx_stub
server {
        listen 127.0.0.1:80;
        server_name 127.0.0.1;

         location /nginx_status {
                stub_status;
        }
}
EOF

# Confirmar que servico esta inicializado
service nginx start

#Instalacao NetData
wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --no-updates --stable-channel --disable-telemetry --non-interactive

#echo "nameserver 10.1.1.20" >> /etc/resolv.conf
#Incluir dns-server como Servidor DNS principal do Web-server 
sudo sed -i '/nameserver 127.0.0.53/i \nameserver 10.1.1.20 \' /etc/resolv.conf


reboot