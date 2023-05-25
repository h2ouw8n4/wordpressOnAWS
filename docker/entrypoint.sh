#!/bin/bash
set -e

# Check if .htaccess exists in /var/www/html, if not copy the custom one
if [ ! -f /var/www/html/.htaccess ]; then
    cp /custom.htaccess /var/www/html/.htaccess
fi

# Execute whatever command is passed (CMD in Dockerfile or command in docker-compose)
exec "$@"