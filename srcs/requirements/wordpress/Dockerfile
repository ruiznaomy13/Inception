FROM alpine:3.21

LABEL maintainer="ncastell <ncastell@student.42barcelona.com>"

RUN set -x; \
	adduser -u 82 -D -S -G www-data www-data; \
	[ ! -d /var/www/html ]; \
	mkdir -p /var/www/html; \
	chown www-data:www-data /var/www/html; \
	chmod 1777 /var/www/html; \
	apk add --no-cache  \
		curl \
		tar \
		php82 \
		php82-gd \
		php82-zip \
		php82-fpm \
		php82-phar \
		php82-exif \
		php82-intl \
		php82-ctype \
		php82-redis \
		php82-bcmath \
		php82-mysqli \
		php82-tokenizer;

WORKDIR /var/www/html

COPY --chmod=755 tools/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000

CMD ["php-fpm82", "-F", "-R"]