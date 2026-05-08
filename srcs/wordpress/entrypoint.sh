#!/bin/bash
set -e

WP_PATH=/var/www/html

echo "waiting db"
until nc -z mariadb $MYSQL_PORT; do
    echo "waiting db"
    sleep 2
done
echo "db ready"

if [ ! -f "$WP_PATH/wp-config.php" ]; then

    wp core download --path=$WP_PATH --allow-root

    echo "config"
    wp config create \
        --path=$WP_PATH \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:$MYSQL_PORT \
        --allow-root

    echo "wordpress install + admin"
    wp core install \
        --path=$WP_PATH \
        --url=$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    echo "create wp user"
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --path=$WP_PATH \
        --allow-root

    chown -R www-data:www-data $WP_PATH

    echo "wp done"
fi

echo "start php"
exec "$@"
