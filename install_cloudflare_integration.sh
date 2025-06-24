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

echo "Installing Cloudflare Management Integration..."

# Create necessary directories
mkdir -p /var/hostvn/menu/controller/cloudflare
mkdir -p /var/hostvn/menu/python/cloudflare

# Copy files to the destinations
cp -a menu/controller/cloudflare/* /var/hostvn/menu/controller/cloudflare/
cp -a menu/route/cloudflare /var/hostvn/menu/route/
cp -a menu/route/cloudflare_route /var/hostvn/menu/route/
cp -a menu/python/cloudflare/* /var/hostvn/menu/python/cloudflare/
cp -a menu/python/requirements.txt /var/hostvn/menu/python/
cp -a menu/python/setup_cloudflare.sh /var/hostvn/menu/python/

# Add language entries
sed -i '/# Cloudflare language entries/d' /var/hostvn/menu/lang/en
sed -i '/lang_cloudflare_/d' /var/hostvn/menu/lang/en
sed -i '/# Cloudflare language entries/d' /var/hostvn/menu/lang/vi
sed -i '/lang_cloudflare_/d' /var/hostvn/menu/lang/vi

# Append language entries
cat >> /var/hostvn/menu/lang/en << 'EOL'
# Cloudflare language entries
lang_cloudflare_management="Cloudflare Management"
lang_cloudflare_api="Set Cloudflare API Key"
lang_cloudflare_add_domain="Add domain to Cloudflare"
lang_cloudflare_manage_dns="Manage DNS Records"
lang_cloudflare_security_rules="Block IP/Country"
lang_cloudflare_manage_cache="Manage Cache"
lang_cloudflare_block_ai_bots="Block AI Bots"
lang_cloudflare_email_routing="Email Routing"
lang_cloudflare_turnstile="Turnstile Management"
lang_cloudflare_security_mode="Security Mode Settings"
EOL

cat >> /var/hostvn/menu/lang/vi << 'EOL'
# Cloudflare language entries
lang_cloudflare_management="Quản Lý Cloudflare"
lang_cloudflare_api="Thiết lập Cloudflare API Key"
lang_cloudflare_add_domain="Thêm tên miền vào Cloudflare"
lang_cloudflare_manage_dns="Quản lý DNS Records"
lang_cloudflare_security_rules="Chặn IP/Quốc gia"
lang_cloudflare_manage_cache="Quản lý Cache"
lang_cloudflare_block_ai_bots="Chặn AI Bots"
lang_cloudflare_email_routing="Định tuyến Email"
lang_cloudflare_turnstile="Quản lý Turnstile"
lang_cloudflare_security_mode="Thiết lập chế độ bảo mật"
EOL

# Update main menu to include Cloudflare
grep -q "menu_cloudflare" /var/hostvn/menu/hostvn || sed -i '/source \/var\/hostvn\/ipaddress/a source /var/hostvn/menu/route/cloudflare_route' /var/hostvn/menu/hostvn
grep -q "16) clear; menu_cloudflare" /var/hostvn/menu/hostvn || sed -i '/15) clear ; change_language;;/a \ \ \ \ \ \ \ \ 16) clear; menu_cloudflare;;' /var/hostvn/menu/hostvn
grep -q "16. \${lang_cloudflare_management}" /var/hostvn/menu/hostvn || sed -i '/15. Change language/a \ \ \ \ printf "${GREEN}%s${NC}\\n" "16. ${lang_cloudflare_management}"' /var/hostvn/menu/hostvn

# Make scripts executable
chmod +x /var/hostvn/menu/controller/cloudflare/*
chmod +x /var/hostvn/menu/route/cloudflare
chmod +x /var/hostvn/menu/route/cloudflare_route
chmod +x /var/hostvn/menu/python/cloudflare/*.py
chmod +x /var/hostvn/menu/python/setup_cloudflare.sh

# Run setup script for Python dependencies
bash /var/hostvn/menu/python/setup_cloudflare.sh

echo "Cloudflare Management Integration installed successfully!"
