#!/bin/sh

if ! touch /etc/nginx/nginx.conf 2>/dev/null; then
    echo "ERROR: can't modify /etc/nginx/nginx.conf"
    exit 1
fi

echo "NGINX configuration correctly! Ready to run up! :)"

exec "$@"

