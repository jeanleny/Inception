#!/bin/bash
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

echo ">>> Starting temporary MariaDB to run init SQL..."

# Start MariaDB in the background temporarily
mysqld --user=mysql --skip-networking &
MYSQL_PID=$!
# ^ save its process ID so we can kill it later

# Wait until MariaDB is actually ready to accept connections
until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent 2>/dev/null; do
    echo "  waiting for temp MariaDB..."
    sleep 1
done

echo ">>> Running init SQL..."
mysql --socket=/run/mysqld/mysqld.sock << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

echo ">>> SQL done, stopping temporary MariaDB..."

# Shut down the temporary MariaDB process
kill $MYSQL_PID
# Wait for it to fully stop before we start the real one
wait $MYSQL_PID 2>/dev/null || true

echo ">>> Starting real MariaDB..."
exec mysqld --user=mysql --bind-address=0.0.0.0
