#!/bin/bash

yum install -y gcc gcc-c++ git
mkdir /usr/local/nginx
cp /vagrant/nginx-1.15.0.tar.gz /usr/local/nginx
cp /vagrant/pcre-8.42.tar.gz /usr/local/nginx
cp /vagrant/openssl-1.0.2o.tar.gz /usr/local/nginx
cp /vagrant/nginx.service /etc/systemd/system/nginx.service
cp /vagrant/nginx-module-vts-master.zip /usr/local/nginx


yum -y install unzip

cd /usr/local/nginx
tar -zxvf nginx-1.15.0.tar.gz
tar -zxvf pcre-8.42.tar.gz
tar -zxvf openssl-1.0.2o.tar.gz
unzip nginx-module-vts-master.zip

#installing nginx server
cd nginx-1.15.0
./configure --prefix=/home/vagrant/nginx --sbin-path=/home/vagrant/nginx/sbin/nginx --conf-path=/home/vagrant/nginx/conf/nginx.conf --error-log-path=/home/vagrant/nginx/logs/error.log --http-log-path=/home/vagrant/nginx/logs/access.log --pid-path=/home/vagrant/nginx/logs/nginx.pid --with-pcre=/usr/local/nginx/pcre-8.42 --without-http_gzip_module --with-openssl=/usr/local/nginx/openssl-1.0.2o --with-http_ssl_module --with-http_realip_module --user=vagrant --add-module=/usr/local/nginx/nginx-module-vts-master
make
make install

#configuring nginx server
cp /vagrant/nginx_lb.conf /home/vagrant/nginx/conf/nginx.conf
mkdir /home/vagrant/nginx/conf/vhosts
mkdir /home/vagrant/nginx/conf/upstreams
cp /vagrant/lb.conf /home/vagrant/nginx/conf/vhosts/lb.conf
cp /vagrant/web.conf /home/vagrant/nginx/conf/upstreams/web.conf

#configuring firewall
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-port=443/tcp
firewall-cmd --reload
firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=8080
firewall-cmd --zone=public --add-forward-port=port=443:proto=tcp:toport=8443

systemctl restart nginx

#creating self-signed SSL certificate key
mkdir /home/vagrant/ssl
openssl genrsa -out /home/vagrant/ssl/server.key 2048
#openssl req -new -key /home/vagrant/ssl/server.key -out /home/vagrant/ssl/server.csr
openssl req -new -key /home/vagrant/ssl/server.key -out /home/vagrant/ssl/server.csr -passin pass:1234 -subj "/C=12/ST=2/L=3/O=4/OU=5/CN=6/emailAddress=7"
openssl x509 -req -days 365 -in /home/vagrant/ssl/server.csr -signkey /home/vagrant/ssl/server.key -out /home/vagrant/ssl/server.crt
chmod 700 /home/vagrant/ssl
chmod 600 /home/vagrant/ssl/server.key
chmod 600 /home/vagrant/ssl/server.crt


#err.html located on LB
cp /vagrant/err.html /home/vagrant/nginx/html


#init script for load-balancer
systemctl daemon-reload
systemctl enable nginx.service
systemctl restart nginx


