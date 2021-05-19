#!/bin/bash

. "/app/bash/bash_library/lib/bash.bash"

BASH_LIBS="/app/bash/bash_library/lib"

add_lib "print.bash"

DOCKER_ERROR_MSG="Could not run MySQL command %s"
DOCKER_SUCCESS_MSG="MySQL command completed"

function docker_mysql {
    DOCKER_COMPOSE=`printf "mysql -uroot -proot -e \"%s\"" "$1"`
    DOCKER_OUTPUT=`bash -c "$DOCKER_COMPOSE"`
    
    if [ $? -ne 0 ]
    then
        DOCKER_MSG=`printf "$DOCKER_ERROR_MSG" "$2"`
        print_error "$DOCKER_MSG"
        exit 1
    else 
        DOCKER_MSG=`printf "$DOCKER_SUCCESS_MSG" "$2"`
        print_success "$DOCKER_MSG"
    fi
}

function docker_mysql_read_file {
    DOCKER_COMPOSE=`printf "mysql -uroot -proot http_web_spider < '%s'" "$1"`
    DOCKER_OUTPUT=`bash -c "$DOCKER_COMPOSE"`
    
    if [ $? -ne 0 ]
    then
        DOCKER_MSG=`printf "$DOCKER_ERROR_MSG" "$2"`
        print_error "$DOCKER_MSG"
        exit 1
    else 
        DOCKER_MSG=`printf "$DOCKER_SUCCESS_MSG" "$2"`
        print_success "$DOCKER_MSG"
    fi
}

docker_mysql "DROP DATABASE IF EXISTS http_web_spider"
docker_mysql "CREATE DATABASE http_web_spider DEFAULT CHARACTER SET utf8"
docker_mysql "DROP USER IF EXISTS 'web_spider'@'%'"
docker_mysql "CREATE USER 'web_spider'@'%' IDENTIFIED BY 'ASJkgkAS8%a5kS'"
docker_mysql "GRANT INSERT on http_web_spider.* to web_spider@'%'"
docker_mysql_read_file "/opt/service/quantum_foam/http_spider.sql"