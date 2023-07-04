#!/bin/bash
set -euo pipefail

# Generate nginx.conf with substituted environment variables
envsubst '${server_ip} ${server_port}' < /etc/nginx/conf.d/nginx.template > /etc/nginx/conf.d/default.conf

# Generate index.html from template with substituted environment variables
envsubst '${server_ip} ${server_port}' < /usr/share/nginx/html/index.html.template > /usr/share/nginx/html/index.html


# Start nginx in foreground
nginx -g 'daemon off;'
