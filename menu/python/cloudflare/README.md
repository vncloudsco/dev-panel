# Cloudflare Management Integration

This directory contains Python scripts for integrating Cloudflare API functionality into the HOSTVN script system.

## Features

- **API Key Management**: Set and validate Cloudflare Global API key
- **Domain Management**: Add domains to Cloudflare
- **DNS Management**: Create, list, and delete DNS records
- **Security Rules**: Block IPs and countries by ISO code
- **Cache Management**: Configure cache settings, purge cache
- **AI Bot Protection**: Block AI bots from scraping your site
- **Email Routing**: Configure Cloudflare Email Routing
- **Turnstile**: Create and manage Turnstile (CAPTCHA alternative)
- **Security Modes**: Toggle Under Attack and Development modes

## Requirements

- Python 3.x
- CloudFlare Python package

## Installation

Run the `setup_cloudflare.sh` script to install the required Python packages:

```bash
bash setup_cloudflare.sh
```

The CloudFlare Python package will be installed using pip.

## Configuration

Before using the Cloudflare features, you need to set your Cloudflare Global API key. 
This key should have full account permissions to use all features.

1. Go to the main HOSTVN menu
2. Select "16. Quản Lý Cloudflare"
3. Choose "1. Set Cloudflare API Key"
4. Enter your Cloudflare email and Global API key

## Documentation

Each Python script includes inline documentation. The main module is:

- `cloudflare_api.py`: Core functionality for interacting with Cloudflare API

For detailed information about the Cloudflare API, visit:
https://api.cloudflare.com/
