#!/bin/bash
set -euo pipefail
envsubst '$$NGINX_SERVER_NAME $$NGINX_PROXY_PASS' < /usr/share/nginx/html/index.html.template > /usr/share/nginx/html/index.html
exec "$@"
