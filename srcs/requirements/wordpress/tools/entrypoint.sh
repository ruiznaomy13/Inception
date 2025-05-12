#!/bin/sh
set -e

if [ "$1" = 'php-fpm82' ]; then
    sed -i 's|^listen = .*|listen = 9000|' /etc/php82/php-fpm.d/www.conf
	if [ ! -f "wp-cli.phar" ]; then
		echo "WordPress: Downloading wp-cli..."
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	fi
	wp() {
		php82 -d memory_limit=256M wp-cli.phar "$@"
	}
	if [ ! -f "index.php" ]; then
		echo "WordPress: Downloading WordPress..."
		wp core download
	fi
	if [ ! -f "wp-config.php" ]; then
		echo "WordPress: Configuring WordPress..."
		wp config create \
			--dbname="$WORDPRESS_DB_NAME" \
			--dbuser="$WORDPRESS_DB_USER" \
			--dbpass="$WORDPRESS_DB_PASSWORD" \
			--dbhost="$WORDPRESS_DB_HOST"


		wp core install \
			--title="Inception" \
			--url="$WORDPRESS_URL" \
			--admin_user="$WORDPRESS_DB_USER" \
			--admin_password="$WORDPRESS_DB_PASSWORD" \
			--admin_email="$WORDPRESS_DB_USER@example.com"
	fi

    echo "WordPress: Config initialized."
fi

exec "$@"
