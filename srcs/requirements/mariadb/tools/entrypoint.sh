#!/bin/sh

if [$1 = "mariadbd"]; then

	if [ -d "/run/mysqld" ]; then
		echo "[i] mysqld already present, skipping creation"
		chown -R mysql:mysql /run/mysqld
	else
		echo "[i] mysqld not found, creating...."
		mkdir -p /run/mysqld
		chown -R mysql:mysql /run/mysqld
	fi

	if [ -d /var/lib/mysql/mysql ]; then
		echo "[i] DB data directory already present, skipping creation"
		chown -R mysql:mysql /var/lib/mysql
	else
		echo "[i] DB data directory not found, creating initial DBs"

		chown -R mysql:mysql /var/lib/mysql

		mariadb-install-db --user=mysql --ldata=/var/lib/mysql > /dev/null

		tfile=$(mktemp)
		if [ ! -f "$tfile" ]; then
			return 1
		fi

		cat <<-EOF > "$tfile"
			USE mysql;
			FLUSH PRIVILEGES ;
			GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
			GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
			SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
			DROP DATABASE IF EXISTS test ;
			FLUSH PRIVILEGES ;
		EOF

		if [ "$MYSQL_DATABASE" != "" ]; then
			echo "[i] Creating database: $MYSQL_DATABASE"
			echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
			echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> "$tfile"

			if [ "$MYSQL_USER" != "" ]; then
				echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
				echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> "$tfile"
			fi
		fi

		mariadbd --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$tfile"
		rm -f "$tfile"

		echo
		echo 'DB init process done. Ready for start up.'
		echo

		echo "exec /usr/bin/mariadbd --user=mysql --console --skip-name-resolve --skip-networking=0" "$@"
	fi	
fi


exec "$@"