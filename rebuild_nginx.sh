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
# Exit on any error
set -e

# Install required packages
apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libpcre3 \
    libpcre3-dev \
    unzip \
    uuid-dev \
    git \
    wget \
    curl

# Configuration
readonly UPDATE_LINK="https://tinyactive.github.io/panel/update"
readonly MODULE_PATH="/usr/share/nginx_module"
readonly MODULES_LINK="https://tinyactive.github.io/panel/modules"

# Create module directory
mkdir -p "${MODULE_PATH}"

# Fetch version information
echo "Fetching version information..."
version_info=$(curl -s "${UPDATE_LINK}/version")
NGINX_VERSION=$(echo "$version_info" | grep "nginx_version=" | cut -f2 -d'=')
NPS_VERSION=$(echo "$version_info" | grep "nps_version=" | cut -f2 -d'=')
ngx_cache_purge_version=$(echo "$version_info" | grep "ngx_cache_purge_version=" | cut -f2 -d'=')
more_clear_headers_v=$(echo "$version_info" | grep "more_clear_headers_v=" | cut -f2 -d'=')
openssl_version=$(echo "$version_info" | grep "openssl_version=" | cut -f2 -d'=')
pcre_version=$(echo "$version_info" | grep "pcre_version=" | cut -f2 -d'=')
zlib_version=$(echo "$version_info" | grep "zlib_version=" | cut -f2 -d'=')

# Validate required variables
for var in NGINX_VERSION NPS_VERSION ngx_cache_purge_version more_clear_headers_v openssl_version pcre_version zlib_version; do
    if [[ -z "${!var}" ]]; then
        echo "Error: $var is empty" >&2
        exit 1
    fi
done

echo "Using NGINX version: ${NGINX_VERSION}"

# Clean and setup module directory
cd "${MODULE_PATH}"
rm -rf ./*

# Download and extract modules
echo "Downloading modules..."
{
    wget -q -O- "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" | tar -xz
    wget -q -O- "${MODULES_LINK}/ngx_cache_purge-${ngx_cache_purge_version}.tar.gz" | tar -xz
    wget -q -O- "${MODULES_LINK}/openssl-OpenSSL_${openssl_version}.tar.gz" | tar -xz
    wget -q -O- "ftp://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.tar.gz" | tar -xz
    wget -q -O- "https://www.zlib.net/zlib-${zlib_version}.tar.gz" | tar -xz
    wget -q -O- "${MODULES_LINK}/headers-more-nginx-module-${more_clear_headers_v}.tar.gz" | tar -xz
} &

# Wait for downloads to complete
wait
cd "${MODULE_PATH}"
# Configure and compile NGINX
echo "Configuring NGINX..."
cd "${MODULE_PATH}/nginx-${NGINX_VERSION}/"
./configure \
       "--user=nginx" \
       "--group=nginx" \
       "--prefix=/var/www/html" \
       "--sbin-path=/usr/sbin" \
       "--conf-path=/etc/nginx/nginx.conf" \
       "--pid-path=/var/run/nginx.pid" \
       "--http-log-path=/var/log/nginx/access_log" \
       "--error-log-path=/var/log/nginx/error_log" \
       "--without-mail_imap_module" \
       "--without-mail_smtp_module" \
       "--with-http_ssl_module" \
       "--with-http_realip_module" \
       "--with-http_stub_status_module" \
       "--with-http_gzip_static_module" \
       "--with-http_dav_module" \
       "--with-http_v2_module" \
       "--with-pcre=../pcre-${pcre_version}" \
       "--with-pcre-jit" \
       "--with-zlib=../zlib-${zlib_version}" \
       "--with-openssl=../openssl-OpenSSL_${openssl_version}" \
       "--with-openssl-opt=no-nextprotoneg" \
       "--add-module=../ngx_cache_purge-${ngx_cache_purge_version}" \
       "--add-module=../headers-more-nginx-module-${more_clear_headers_v}" \
       "--add-module=../nginx-module-vts-${nginx_module_vts_v}" \
       "--with-cc-opt='-D FD_SETSIZE=32768'" 

echo "Compiling NGINX..."
make -j"$(nproc)" && make install

echo "NGINX rebuild completed successfully!"
