#!/usr/bin/env python3
"""
Cloudflare API module for HOSTVN Scripts
"""
import os
import json
import sys
import CloudFlare

CONFIG_FILE = '/var/hostvn/.cloudflare.conf'

def load_config():
    """Load Cloudflare API configuration"""
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            return None
    return None

def save_config(email, api_key):
    """Save Cloudflare API configuration"""
    config = {
        'email': email,
        'api_key': api_key
    }
    try:
        with open(CONFIG_FILE, 'w') as f:
            json.dump(config, f)
        # Set secure permissions
        os.chmod(CONFIG_FILE, 0o600)
        return True
    except IOError:
        return False

def get_cf_client():
    """Get authenticated Cloudflare client"""
    config = load_config()
    if not config:
        print("Cloudflare API configuration not found! Please set up your API key first.")
        return None
    
    try:
        cf = CloudFlare.CloudFlare(email=config['email'], token=config['api_key'])
        # Test the connection
        cf.user.get()
        return cf
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        print(f"API Error: {e}")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None

def validate_api_key(email, api_key):
    """Validate Cloudflare API key"""
    try:
        cf = CloudFlare.CloudFlare(email=email, token=api_key)
        user = cf.user.get()
        return True, user
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def get_domains():
    """Get list of domains on Cloudflare account"""
    cf = get_cf_client()
    if not cf:
        return []
    
    try:
        zones = cf.zones.get(params={'per_page': 100})
        return zones
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        print(f"API Error: {e}")
        return []
    except Exception as e:
        print(f"Error: {e}")
        return []

def add_domain(domain_name):
    """Add domain to Cloudflare"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    try:
        zone_info = {
            'name': domain_name,
            'jump_start': True
        }
        result = cf.zones.post(data=zone_info)
        return True, result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def get_domain_id(domain_name):
    """Get domain ID from domain name"""
    cf = get_cf_client()
    if not cf:
        return None
    
    try:
        zones = cf.zones.get(params={'name': domain_name})
        if len(zones) == 0:
            return None
        return zones[0]['id']
    except CloudFlare.exceptions.CloudFlareAPIError:
        return None
    except Exception:
        return None

def add_dns_record(domain_name, record_type, name, content, proxied=True):
    """Add DNS record to domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        dns_record = {
            'type': record_type,
            'name': name,
            'content': content,
            'proxied': proxied
        }
        result = cf.zones.dns_records.post(zone_id, data=dns_record)
        return True, result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def get_dns_records(domain_name):
    """Get DNS records for domain"""
    cf = get_cf_client()
    if not cf:
        return []
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return []
    
    try:
        dns_records = cf.zones.dns_records.get(zone_id)
        return dns_records
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        print(f"API Error: {e}")
        return []
    except Exception as e:
        print(f"Error: {e}")
        return []

def update_security_level(domain_name, security_level):
    """Update security level for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        result = cf.zones.settings.security_level.patch(zone_id, data={'value': security_level})
        return True, result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def toggle_development_mode(domain_name, enabled=True):
    """Toggle development mode for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        value = 'on' if enabled else 'off'
        result = cf.zones.settings.development_mode.patch(zone_id, data={'value': value})
        return True, result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def purge_cache(domain_name):
    """Purge all cached content for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        result = cf.zones.purge_cache.post(zone_id, data={'purge_everything': True})
        return True, result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def block_country(domain_name, country_codes):
    """Block countries for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        # Create a firewall rule to block countries
        expressions = []
        for country in country_codes:
            expressions.append(f"(ip.geoip.country eq \"{country}\")")
        
        expression = " or ".join(expressions)
        
        # First create a filter
        filter_data = {
            'name': 'Block Countries',
            'description': 'Block specific countries',
            'expression': expression
        }
        
        filter_result = cf.zones.filters.post(zone_id, data=filter_data)
        filter_id = filter_result['id']
        
        # Then create a firewall rule using the filter
        rule_data = {
            'filter': {'id': filter_id},
            'action': 'block',
            'description': 'Block traffic from specific countries'
        }
        
        rule_result = cf.zones.firewall.rules.post(zone_id, data=rule_data)
        return True, rule_result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def block_ai_bots(domain_name):
    """Block AI bots for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        # Create a firewall rule to block AI bots
        filter_data = {
            'name': 'Block AI Bots',
            'description': 'Block AI bots like ChatGPT, Bard, etc.',
            'expression': '(cf.client.bot) or (http.user_agent contains "GPTBot") or (http.user_agent contains "ChatGPT") or (http.user_agent contains "Google-Extended")'
        }
        
        filter_result = cf.zones.filters.post(zone_id, data=filter_data)
        filter_id = filter_result['id']
        
        # Then create a firewall rule using the filter
        rule_data = {
            'filter': {'id': filter_id},
            'action': 'block',
            'description': 'Block AI bots from accessing the site'
        }
        
        rule_result = cf.zones.firewall.rules.post(zone_id, data=rule_data)
        return True, rule_result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def enable_email_routing(domain_name):
    """Enable Email Routing for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        # Enable Email Routing
        result = cf.zones.email.routing.enable.post(zone_id)
        
        # Add catch-all rule
        rule_data = {
            'name': 'Catch All',
            'enabled': True,
            'matcher': {
                'type': 'all'
            },
            'actions': [
                {
                    'type': 'forward',
                    'value': ['admin@example.com']  # This should be configured by the user
                }
            ]
        }
        
        rule_result = cf.zones.email.routing.rules.post(zone_id, data=rule_data)
        return True, rule_result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def create_turnstile(domain_name, name):
    """Create Turnstile for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    try:
        # Get account ID first
        accounts = cf.accounts.get()
        if not accounts:
            return False, "No accounts found"
        
        account_id = accounts[0]['id']
        
        # Create turnstile widget
        turnstile_data = {
            'name': name,
            'domains': [domain_name],
            'mode': 'managed'
        }
        
        result = cf.accounts.turnstile.widgets.post(account_id, data=turnstile_data)
        return True, result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def configure_tiered_cache(domain_name, enabled=True):
    """Configure Tiered Cache for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        value = 'on' if enabled else 'off'
        result = cf.zones.settings.tiered_caching.patch(zone_id, data={'value': value})
        return True, result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

def configure_cache_reserve(domain_name, enabled=True):
    """Configure Cache Reserve for domain"""
    cf = get_cf_client()
    if not cf:
        return False, "API client not available"
    
    zone_id = get_domain_id(domain_name)
    if not zone_id:
        return False, f"Domain {domain_name} not found"
    
    try:
        value = 'on' if enabled else 'off'
        result = cf.zones.settings.cache_reserve.patch(zone_id, data={'value': value})
        return True, result
    except CloudFlare.exceptions.CloudFlareAPIError as e:
        return False, f"API Error: {e}"
    except Exception as e:
        return False, f"Error: {e}"

# Command-line interface for calling from bash
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: cloudflare.py <command> [args...]")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "set_api":
        if len(sys.argv) != 4:
            print("Usage: cloudflare.py set_api <email> <api_key>")
            sys.exit(1)
        email = sys.argv[2]
        api_key = sys.argv[3]
        valid, user = validate_api_key(email, api_key)
        if valid:
            save_config(email, api_key)
            print("API key set successfully")
            sys.exit(0)
        else:
            print(f"Invalid API key: {user}")
            sys.exit(1)
    
    elif command == "add_domain":
        if len(sys.argv) != 3:
            print("Usage: cloudflare.py add_domain <domain_name>")
            sys.exit(1)
        domain_name = sys.argv[2]
        success, result = add_domain(domain_name)
        if success:
            print(f"Domain {domain_name} added successfully")
            # Print nameservers
            if 'name_servers' in result:
                print("Please update your domain's nameservers to:")
                for ns in result['name_servers']:
                    print(f"  - {ns}")
            sys.exit(0)
        else:
            print(f"Failed to add domain: {result}")
            sys.exit(1)
    
    # Add more command-line handlers for other functions as needed
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)
