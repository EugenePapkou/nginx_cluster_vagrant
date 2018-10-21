#!/bin/bash

#cp /vagrant/NGINX.repo /etc/yum.repos.d/NGINX.repo
#yum -y install nginx

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

cd nginx-1.15.0
./configure --prefix=/home/vagrant/nginx --sbin-path=/home/vagrant/nginx/sbin/nginx --conf-path=/home/vagrant/nginx/conf/nginx.conf --error-log-path=/home/vagrant/nginx/logs/error.log --http-log-path=/home/vagrant/nginx/logs/access.log --pid-path=/home/vagrant/nginx/logs/nginx.pid --with-pcre=/usr/local/nginx/pcre-8.42 --without-http_gzip_module --with-openssl=/usr/local/nginx/openssl-1.0.2o --with-http_ssl_module --with-http_realip_module --user=vagrant --add-module=/usr/local/nginx/nginx-module-vts-master
make
make install

cp /vagrant/html.tar.gz /home/vagrant/nginx/
cd /home/vagrant/nginx/
tar -zxvf html.tar.gz

cp /vagrant/nginx_nodes.conf /home/vagrant/nginx/conf/nginx.conf
cp /vagrant/backend_node2.conf /home/vagrant/nginx/conf/backend.conf
printf "admin:$(openssl passwd -crypt nginx)\n" >> /home/vagrant/nginx/conf/.htpasswd


systemctl daemon-reload
systemctl enable nginx.service
systemctl start nginx


