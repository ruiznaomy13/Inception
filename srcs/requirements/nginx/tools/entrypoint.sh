#!/bin/sh

if ! touch /etc/nginx/nginx.conf 2>/dev/null; then
    echo "ERROR: can't modify /etc/nginx/nginx.conf"
    exit 1
fi

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/ssl/ncastell.key \
		-out /etc/nginx/ssl/ncastell.crt \
		-subj "/C=ES/ST=Catalunia/L=Barcelona/O=42Barcelona/OU=Fundacion Telefonica/CN=ncastell.42.fr"

sed -i '/http {/a \
server {\
	listen 443 ssl;\
	server_name ncastell.42.fr;\
	ssl_certificate /etc/nginx/ssl/ncastell.crt;\
	ssl_certificate_key /etc/nginx/ssl/ncastell.key;\
	ssl_protocols TLSv1.2 TLSv1.3;\
}' /etc/nginx/nginx.conf


echo "NGINX configuration correctly! Ready to run up! :)"

exec "$@"

