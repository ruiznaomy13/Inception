FROM alpine:3.20

RUN set -x \
	&& addgroup -g 101 -S nginx \
	&& adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
	&& apk add --no-cache nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


