#!/bin/bash

######################################################################
#           Auto Install & Optimize LEMP Stack on Ubuntu             #
#                                                                    #
#                Author: Sanvv - HOSTVN Technical                    #
#                  Website: https://hostvn.vn                        #
#                                                                    #
#              Please do not remove copyright. Thank!                #
#  Please do not copy under any circumstance for commercial reason!  #
######################################################################

# This script should be run on install to set up Python requirements
echo "Setting up Python dependencies for Cloudflare integration..."

# Check if python3 is installed
if ! command -v python3 >/dev/null 2>&1; then
    echo "Installing Python 3..."
    apt-get update
    apt-get install -y python3 python3-pip
fi

# Install required Python modules
echo "Installing required Python modules..."
pip3 install -r /var/hostvn/menu/python/requirements.txt

# Set proper permissions
chmod -R +x /var/hostvn/menu/controller/cloudflare/
chmod -R +x /var/hostvn/menu/python/cloudflare/

echo "Cloudflare integration setup complete!"
