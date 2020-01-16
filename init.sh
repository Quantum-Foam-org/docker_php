docker network create --subnet=172.27.0.0/28 --gateway=172.27.0.1  symfony_php_bridge
sudo iptables -I INPUT -p tcp --dport 9000 -j ACCEPT
docker build -t symfony_php:7.4.1 .
# install composer
# install symfony
# install api 
