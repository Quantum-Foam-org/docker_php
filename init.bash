#!/bin/bash

GIT_ERROR_MSG="Could not clone %s from Quantum Foam. Please make sure that git is installed."
GIT_SUCCESS_MSG="Cloned %s Quantum Foam Repository"

function git_clone {
    GIT_CLONE=`printf "cd app/%s && git clone %s" "$1" "$2"`
    GIT_OUTPUT=`bash -c "$GIT_CLONE"`
    
    if [ $? -ne 0 ]
    then
        GC_MSG=`printf "$GIT_ERROR_MSG" "$2"`
        print_error "$GC_MSG"
        exit 3
    else 
        GC_MSG=`printf "$GIT_SUCCESS_MSG" "$2"`
        print_success "$GC_MSG"
    fi
}

if [ ! -d "app/bash/bash_library" ]
then
    GIT_OUTPUT=`cd app/bash && git clone https://github.com/Quantum-Foam-org/bash_library.git`
    echo $GIT_OUTPUT
    if [ $? -ne 0 ]
    then
        GC_MSG=`printf "$GIT_ERROR_MSG" "bash_library"`
        exit 2
    fi
else 
    QF_BASH_REPO=`cd app/bash/bash_library && git config --get remote.origin.url`
    if [[ !$QF_BASH_REPO == "git@github.com:Quantum-Foam-org/bash_library.git" ]]
    then
        echo "Please verify that app/bash/bash_library is the bash_library repository from Quantum Foam"
        exit 4
    else
        GIT_OUTPUT=`cd app/bash/bash_library && git pull`
        echo $GIT_OUTPUT
    fi
fi
        




. "./app/bash/bash_library/lib/bash.bash"

BASH_LIBS="./app/bash/bash_library/lib"

add_lib "print.bash"
add_lib "file.bash"

print_info "Setting up local docker instance"
print_prompt "Purge old install?"

echo $BASH_LIB_PROMPT
if [[ ${BASH_LIB_PROMPT^^} == 'Y' ]]
then
    print_info "Purging old install"
    DOCKER_IMG=`sudo docker image rm -f docker_qf_php`
    DOCKER_IMG=`sudo docker image rm -f docker_qf_mysql`

    DOCKER_QF_BRIDGE=`sudo docker network rm docker_qf_bridge`

    DOCKER_MONGODB=`sudo docker volume rm -f docker_qf_mongodb_data`

    DOCKER_MYSQL=`sudo docker volume rm -f docker_qf_mysql_data`
    
    PHP_CODE=("php_common" "php_cli" "MemcacheStats" "php_unit_tests" "HTTP_Testing_Utilities")
    for DIR in ${PHP_CODE[@]}
    do
        RM_CMD=`printf "rm -rf app/php/%s" "$DIR"`
        RM_GIT=`$RM_CMD`
    done
    
    RM_GIT=`rm -rf app/web-root/php_mvc_framework`
fi


print_info "Checking out Quantum Foam PHP code"

git_clone "php" "https://github.com/Quantum-Foam-org/php_common.git"
git_clone "php" "https://github.com/Quantum-Foam-org/HTTP_Testing_Utilities.git"
git_clone "php" "https://github.com/Quantum-Foam-org/php_unit_tests.git"
git_clone "php" "https://github.com/Quantum-Foam-org/php_cli.git"
git_clone "php" "https://github.com/Quantum-Foam-org/MemcacheStats.git"
git_clone "web-root" "https://github.com/Quantum-Foam-org/php_mvc_framework.git"

print_info "Creating docker_qf_bridge network"
DOCKER_NF=`sudo docker network create --subnet=172.27.0.0/28 --gateway=172.27.0.1  docker_qf_bridge`
if [ $? -ne 0 ]
then
    print_error "Unable to create docker_qf_bridge"
    print_info $DOCKER_NF
else 
    print_success "Created docker_qf_bridge docker network"
fi

print_info "Creating docker_qf_mongodb_data volume"
DOCKER_MONGO=`sudo docker volume create docker_qf_mongodb_data`
if [ $? -ne 0 ]
then
    print_error "Unable to create docker_qf_mongodb_data"
    print_info $DOCKER_MONGO
else 
    print_success "Created docker_qf_mongodb_data docker volume"
fi

print_info "Creating docker_qf_mysql_data volume"
DOCKER_MYSQL=`sudo docker volume create docker_qf_mysql_data`
if [ $? -ne 0 ]
then
    print_error "Unable to create docker_qf_mysql_data"
    print_info $DOCKER_MYSQL
else 
    print_success "Created docker_qf_mysql_data docker volume"
fi

print_info "building docker container docker_qf_php"
DOCKER_BUILD=`sudo docker build --target docker_qf_php -t docker_qf_php .`
if [ $? -ne 0 ]
then
    print_error "Unable to build docker_qf_php"
    print_info "$DOCKER_BUILD"
else
    print_success "Built docker_qf_php"
    write_file "$DOCKER_BUILD" "docker_qf.build"
    print_info "Check docker_qf.build text file for status"
fi

print_info "building docker container docker_qf_mysql"
DOCKER_BUILD=`sudo docker build --target docker_qf_mysql -t docker_qf_mysql .`
if [ $? -ne 0 ]
then
    print_error "Unable to build docker_qf_mysql"
    print_info "$DOCKER_BUILD"
else
    print_success "Built docker_qf_mysql"
    write_file "$DOCKER_BUILD" "docker_qf.build"
    print_info "Check docker_qf.build text file for status"
fi
