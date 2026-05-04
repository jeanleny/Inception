#!/bin/bash
# Stop immediately if any command fails
set -e

WP_PATH=/var/www/html

echo "Waiting for MariaDB..."
# Loop until MariaDB responds
# mysqladmin ping sends a test connection to the mariadb container
# -h mariadb    → "mariadb" is the service name in docker-compose
#                 Docker DNS resolves it to the container's IP automatically
# --silent      → don't print anything, just return success or failure
# 2>/dev/null   → hide error messages while we're waiting
until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent 2>/dev/null; do
    echo "  not ready yet, retrying in 2s..."
    sleep 2
done
echo "MariaDB is ready."

# wp-config.php is created during WordPress installation
# If it already exists, WordPress is already set up — skip everything
if [ ! -f "$WP_PATH/wp-config.php" ]; then

    echo "Downloading WordPress core files..."
    # wp is WP-CLI — a command line tool to manage WordPress
    # core download fetches the latest WordPress and unpacks it into --path
    # --allow-root lets WP-CLI run as root (which we are inside the container)
    wp core download --path=$WP_PATH --allow-root

    echo "Creating wp-config.php..."
    # wp-config.php is the WordPress configuration file
    # it tells WordPress how to connect to the database
    wp config create \
        --path=$WP_PATH \
        --dbname=$MYSQL_DATABASE \       # database name from your .env
        --dbuser=$MYSQL_USER \           # db user from your .env
        --dbpass=$MYSQL_PASSWORD \       # db password from your .env
        --dbhost=mariadb:3306 \          # "mariadb" = docker-compose service name
        --allow-root

    echo "Installing WordPress..."
    # This creates all the WordPress tables in your database
    # and sets up the admin account
    wp core install \
        --path=$WP_PATH \
        --url=$DOMAIN_NAME \             # your site URL from .env
        --title="$WP_TITLE" \           # site title from .env
        --admin_user=$WP_ADMIN \         # admin username from .env
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \                   # don't try to send a confirmation email
        --allow-root

    echo "Creating second WordPress user..."
    # Inception requires a second non-admin user
    # role=author means they can write posts but not manage the site
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --path=$WP_PATH \
        --allow-root

    echo "Fixing file permissions..."
    # Give www-data ownership of all WordPress files
    # PHP-FPM runs as www-data and needs to read/write these files
    chown -R www-data:www-data $WP_PATH

    echo "WordPress is ready."
fi

echo "Starting PHP-FPM..."
# php-fpm8.2 is the PHP-FPM binary for PHP 8.2 (comes with debian bookworm)
# -F means foreground — without this it would daemonize (go to background)
# and the container would immediately stop because PID 1 exited
exec php-fpm8.2 -F
