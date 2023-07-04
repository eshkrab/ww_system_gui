#!/bin/bash
set -euo pipefail

# Generate nginx.conf with substituted environment variables
envsubst '${server_ip} ${server_port}' < /etc/nginx/conf.d/nginx.template > /etc/nginx/conf.d/default.conf

# Start nginx in foreground
nginx -g 'daemon off;'
