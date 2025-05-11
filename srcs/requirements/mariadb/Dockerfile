FROM alpine:3.20.6

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*

COPY --chmod=755 tools/entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 3306

CMD [ "mariadbd",  "--user=mysql", "--console", "--skip-name-resolve", "--skip-networking=0;" ]