#!/bin/bash
set -euo pipefail

# Replace placeholders in config.js with environment variables
sed -i "s|DEFAULT_SERVER_IP|$server_ip|g" /usr/share/nginx/html/config.js
sed -i "s|DEFAULT_SERVER_PORT|$server_port|g" /usr/share/nginx/html/config.js

# Generate index.html from template with substituted environment variables
 envsubst '${server_ip} ${server_port}' < /usr/share/nginx/html/index.html.template > /usr/share/nginx/html/index.html

# Generate nginx.conf with substituted environment variables
envsubst '${server_ip} ${server_port}' < /etc/nginx/conf.d/nginx.template > /etc/nginx/conf.d/default.conf

# Start nginx in foreground
nginx -g 'daemon off;'

