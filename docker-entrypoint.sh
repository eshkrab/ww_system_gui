#!/bin/bash
set -euo pipefail

# Generate nginx.conf with substituted environment variables
envsubst '${_serverIP} ${_serverPort}' < /etc/nginx/conf.d/nginx.template > /etc/nginx/conf.d/default.conf

# Start nginx in foreground
nginx -g 'daemon off;'
