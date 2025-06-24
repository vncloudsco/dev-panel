#!/bin/bash

######################################################################
#           Auto Install & Optimize LEMP Stack on Ubuntu             #
#                                                                    #
#                Author: TinyActive - Base On HOSTVN.VN Scripts      #
#                  Website: https://github.com/TinyActive/panel      #
#                                                                    #
#              Please do not remove copyright. Thank!                #
#  Please do not copy under any circumstance for commercial reason!  #
######################################################################

source /var/hostvn/menu/helpers/variable_common
source /var/hostvn/menu/helpers/function
DIR="/opt/php-extension"
MODULE_LINK="${HOMEPAGE_LINK}/modules"
IG_BINARY_VERSION=$(curl -s "${UPDATE_LINK}"/version | grep "igbinary_version=" | cut -f2 -d'=')
PHP_REDIS_VERSION=$(curl -s "${UPDATE_LINK}"/version | grep "php_redis_version=" | cut -f2 -d'=')
PHP1_VERSION=$(grep -w "php1_version" "/var/hostvn/.hostvn.conf" | cut -f2 -d'=')
PHP2_RELEASE=$(grep -w "php2_release" "/var/hostvn/.hostvn.conf" | cut -f2 -d'=')
PHP2_VERSION=$(grep -w "php2_version" "/var/hostvn/.hostvn.conf" | cut -f2 -d'=')
PHP1_INI_PATH="/etc/php/${PHP1_VERSION}/fpm/conf.d"
PHP2_INI_PATH="/etc/php/${PHP2_VERSION}/fpm/conf.d"
PHP1_CLI_PATH="/etc/php/${PHP1_VERSION}/cli/conf.d"
PHP2_CLI_PATH="/etc/php/${PHP2_VERSION}/cli/conf.d"

_install_ig_binary_php1(){
    if [[ "${PHP1_VERSION}" == "5.6" ]]; then
        IG_BINARY_VERSION="2.0.8"
    fi

    _cd_dir "${DIR}"
    if [ -f "igbinary-${IG_BINARY_VERSION}.tgz" ]; then
        rm -rf igbinary-"${IG_BINARY_VERSION}".tgz
    fi
    if [ -d "igbinary-${IG_BINARY_VERSION}" ]; then
        rm -rf igbinary-"${IG_BINARY_VERSION}"
    fi
    wget "${MODULE_LINK}"/igbinary-"${IG_BINARY_VERSION}".tgz
    tar -xvf igbinary-"${IG_BINARY_VERSION}".tgz
    _cd_dir igbinary-"${IG_BINARY_VERSION}"
    /usr/bin/phpize"${PHP1_VERSION}" && ./configure --with-php-config=/usr/bin/php-config"${PHP1_VERSION}"
    make && make install
    _cd_dir "${DIR}"
    rm -rf igbinary-"${IG_BINARY_VERSION}" igbinary-"${IG_BINARY_VERSION}".tgz

    rm -rf "$PHP1_INI_PATH"/30-igbinary.ini
    cat >> "$PHP1_INI_PATH/30-igbinary.ini" << EOF
extension=igbinary.so
EOF

    rm -rf "$PHP1_CLI_PATH"/30-igbinary.ini
    cat >> "$PHP1_CLI_PATH/30-igbinary.ini" << EOF
extension=igbinary.so
EOF
    systemctl restart php"${PHP1_VERSION}"-fpm
}

_install_php1_redis(){
    if [[ "${PHP1_VERSION}" == "5.6" ]]; then
        PHP_REDIS_VERSION="4.3.0"
    fi

    _cd_dir "${DIR}"
    if [ -f "redis-${PHP_REDIS_VERSION}.tgz" ]; then
        rm -rf redis-"${PHP_REDIS_VERSION}".tgz
    fi
    if [ -d "memcached-${PHP_REDIS_VERSION}" ]; then
        rm -rf redis-"${PHP_REDIS_VERSION}"
    fi
    wget "${MODULE_LINK}"/redis-"${PHP_REDIS_VERSION}".tgz
    tar -xvf redis-"${PHP_REDIS_VERSION}".tgz
    _cd_dir "${DIR}/redis-${PHP_REDIS_VERSION}"
    /usr/bin/phpize"${PHP1_VERSION}" && ./configure --enable-redis-igbinary --with-php-config=/usr/bin/php-config"${PHP1_VERSION}"
    make && make install
    cd "${DIR}" && rm -rf redis-"${PHP_REDIS_VERSION}".tgz redis-"${PHP_REDIS_VERSION}"

    rm -rf "${PHP1_INI_PATH}"/50-redis.ini
    cat >> "${PHP1_INI_PATH}/50-redis.ini" << EOF
extension=redis.so
EOF

    rm -rf "${PHP1_CLI_PATH}"/50-redis.ini
    cat >> "${PHP1_CLI_PATH}/50-redis.ini" << EOF
extension=redis.so
EOF
}

_install_ig_binary_php2(){
    if [[ "${PHP2_VERSION}" == "5.6" ]]; then
        IG_BINARY_VERSION="2.0.8"
    fi

    _cd_dir "${DIR}"
    if [ -f "igbinary-${IG_BINARY_VERSION}.tgz" ]; then
        rm -rf igbinary-"${IG_BINARY_VERSION}".tgz
    fi
    if [ -d "igbinary-${IG_BINARY_VERSION}" ]; then
        rm -rf igbinary-"${IG_BINARY_VERSION}"
    fi
    wget "${MODULE_LINK}"/igbinary-"${IG_BINARY_VERSION}".tgz
    tar -xvf igbinary-"${IG_BINARY_VERSION}".tgz
    _cd_dir "igbinary-${IG_BINARY_VERSION}"
    /usr/bin/phpize"${PHP2_VERSION}" && ./configure --with-php-config=/usr/bin/php-config"${PHP2_VERSION}"
    make && make install
    cd "${DIR}" && rm -rf igbinary-"${IG_BINARY_VERSION}" igbinary-"${IG_BINARY_VERSION}".tgz

    rm -rf "${PHP2_INI_PATH}"/30-igbinary.ini
    cat >> "${PHP2_INI_PATH}/30-igbinary.ini" << EOF
extension=igbinary.so
EOF

    rm -rf "$PHP2_CLI_PATH"/30-igbinary.ini
    cat >> "$PHP2_CLI_PATH/30-igbinary.ini" << EOF
extension=igbinary.so
EOF
    systemctl restart php"${PHP2_VERSION}"-fpm
}

_install_php2_redis(){
    if [[ "${PHP2_VERSION}" == "5.6" ]]; then
        PHP_REDIS_VERSION="4.3.0"
    fi

    _cd_dir "${DIR}"
    if [ -f "redis-${PHP_REDIS_VERSION}.tgz" ]; then
        rm -rf redis-"${PHP_REDIS_VERSION}".tgz
    fi
    if [ -d "redis-${PHP_REDIS_VERSION}" ]; then
        rm -rf redis-"${PHP_REDIS_VERSION}"
    fi
    wget "${MODULE_LINK}"/redis-"${PHP_REDIS_VERSION}".tgz
    tar -xvf redis-"${PHP_REDIS_VERSION}".tgz
    _cd_dir "${DIR}/redis-${PHP_REDIS_VERSION}"
    /usr/bin/phpize"${PHP2_VERSION}" && ./configure --enable-redis-igbinary --with-php-config=/usr/bin/php-config"${PHP2_VERSION}"
    make && make install
    cd "${DIR}" && rm -rf redis-"${PHP_REDIS_VERSION}".tgz redis-"${PHP_REDIS_VERSION}"

    rm -rf "${PHP2_INI_PATH}"/50-redis.ini
    cat >> "${PHP2_INI_PATH}/50-redis.ini" << EOF
extension=redis.so
EOF

    rm -rf "${PHP2_CLI_PATH}"/50-redis.ini
    cat >> "${PHP2_CLI_PATH}/50-redis.ini" << EOF
extension=redis.so
EOF
}

mkdir -p "${DIR}"
check_ig_binary_php1=$(php"${PHP1_VERSION}" -m | grep igbinary)
check_redis_php1=$(php"${PHP1_VERSION}" -m | grep redis)

if [ -z "$check_ig_binary_php1" ]; then
    _install_ig_binary_php1
    check_ig_binary_php1=$(php"${PHP1_VERSION}" -m | grep igbinary)
fi

if [[ -n "$check_ig_binary_php1" && -z "$check_redis_php1" ]]; then
    _install_php1_redis
fi

if [ "${PHP2_RELEASE}" == "yes" ]; then
    check_ig_binary_php2=$(php"${PHP2_VERSION}" -m | grep igbinary)
    check_redis_php2=$(php"${PHP2_VERSION}" -m | grep redis)

    if [ -z "$check_ig_binary_php2" ]; then
        _install_ig_binary_php2
        check_ig_binary_php2=$(php"${PHP2_VERSION}" -m | grep igbinary)
    fi

    if [[ -n "$check_ig_binary_php2" && -z "$check_redis_php2" ]]; then
        _install_php2_redis
    fi
fi

rm -rf "${DIR}"

