# Cloudflare Management Integration

This integration adds a complete Cloudflare management menu to the HOSTVN script system, allowing you to manage your Cloudflare domains directly from the script interface. The implementation uses Python with the Cloudflare API library to provide comprehensive Cloudflare management capabilities.

## Features

- **Set Cloudflare Global API Key**: Configure and validate your Cloudflare API credentials
- **Add Domain to Cloudflare**: Add new domains to your Cloudflare account
- **Manage DNS Records**: Add, list, and delete DNS records, including automatic VPS A records
- **Security Rules**: Block IP addresses and countries using Security Rules
- **Cache Management**: Configure Cache Reserve, Tiered Cache, and purge cache
- **Block AI Bots**: Create firewall rules to block AI crawlers
- **Email Routing**: Enable and configure Email Routing for domains
- **Turnstile Management**: Create and manage Turnstile widgets
- **Security Mode Settings**: Toggle Under Attack Mode and Development Mode

## Installation

1. Run the installation script:

```bash
bash install_cloudflare_integration.sh
```

This will:
- Create necessary directories
- Copy the Python scripts and bash controllers
- Add language entries
- Update the main menu
- Install required Python dependencies

2. Run HOSTVN script to access the Cloudflare menu:

```bash
hostvn
```

Then select option `16. Quản Lý Cloudflare` from the main menu.

## Requirements

- Python 3.x (automatically installed if missing)
- Cloudflare Python API library (automatically installed)
- A valid Cloudflare account with Global API Key

## Technical Details

The integration consists of:

1. **Python Scripts**: Located in `/var/hostvn/menu/python/cloudflare/`, these scripts interface with the Cloudflare API
2. **Bash Controllers**: Located in `/var/hostvn/menu/controller/cloudflare/`, these scripts provide the user interface
3. **Route Files**: Located in `/var/hostvn/menu/route/`, these connect the controllers to the main menu

The implementation carefully preserves the existing bash shell functionality while adding Python-based Cloudflare features.

## Structure

```
/var/hostvn/
├── menu/
│   ├── controller/
│   │   └── cloudflare/
│   │       ├── set_api_key
│   │       ├── add_domain
│   │       ├── manage_dns
│   │       ├── security_rules
│   │       ├── manage_cache
│   │       ├── block_ai_bots
│   │       ├── email_routing
│   │       ├── turnstile
│   │       └── security_mode
│   ├── route/
│   │   ├── cloudflare
│   │   └── cloudflare_route
│   └── python/
│       ├── cloudflare/
│       │   ├── cloudflare_api.py
│       │   └── README.md
│       ├── requirements.txt
│       └── setup_cloudflare.sh
```

## Language Support

The integration includes localization for both English and Vietnamese interfaces.

## Notes

- The Cloudflare API key is stored securely in `/var/hostvn/.cloudflare.conf`
- Python dependencies are managed using pip and requirements.txt
