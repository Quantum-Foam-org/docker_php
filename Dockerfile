FROM php:7.4.1-apache-buster


RUN ln -s $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

RUN apt-get update ;

RUN apt-get install -y \
         libzip-dev ;\
         docker-php-ext-install zip ;

RUN pecl install xdebug-2.9.0 && \
    docker-php-ext-enable xdebug ;

RUN apt-get install -y net-tools

#COPY conf.d/service/php/entrypoint.sh /usr/local/bin/docker-entrypoint
#RUN chmod +x /usr/local/bin/docker-entrypoint


#ENTRYPOINT ["entrypoint"]
#CMD ["-c"]
