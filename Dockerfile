FROM php:7.4.1-apache-buster as docker_qf_php

RUN ln -s $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

RUN apt-get update ;

RUN docker-php-ext-install pdo pdo_mysql;

RUN pecl install xdebug-2.9.0 && \
    docker-php-ext-enable xdebug ;


#RUN apt-get install -y net-tools

RUN a2enmod rewrite

RUN rm /etc/apache2/sites-enabled/000-default.conf

RUN mkdir -p /opt/etc/apache

COPY conf.d/etc/apache/QF.conf /opt/etc/apache/QF.conf

RUN ln -s /opt/etc/apache/QF.conf /etc/apache2/sites-enabled


FROM mysql:8.0.23 as docker_qf_mysql

RUN mkdir -p /opt/service/quantum_foam

COPY app/php/HTTP_Testing_Utilities/SQLSchema/http_spider.sql /opt/service/quantum_foam/http_spider.sql
COPY conf.d/service/mysql/install.bash /opt/service/quantum_foam/install.bash

#COPY conf.d/service/php/entrypoint.sh /usr/local/bin/docker-entrypoint
#RUN chmod +x /usr/local/bin/docker-entrypoint


#ENTRYPOINT ["entrypoint"]
#CMD ["-c"]
