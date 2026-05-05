#!/bin/bash
set -e

WP_PATH=/var/www/html

echo "Waiting for MariaDB..."
until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent 2>/dev/null; do
    echo "  not ready yet, retrying in 2s..."
    sleep 2
done
echo "MariaDB is ready."

if [ ! -f "$WP_PATH/wp-config.php" ]; then

    echo "Downloading WordPress core files..."
    wp core download --path=$WP_PATH --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --path=$WP_PATH \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --path=$WP_PATH \
        --url=$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    echo "Creating second WordPress user..."
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --path=$WP_PATH \
        --allow-root

    echo "Fixing file permissions..."
    chown -R www-data:www-data $WP_PATH

    echo "WordPress is ready."
fi

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
