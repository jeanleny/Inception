#!/bin/bash
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

echo "mariadb start"

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	mysqld --user=mysql --skip-networking &
	MYSQL_PID=$!
	until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent 2>/dev/null; do
	    echo "mariadb waiting"
	    sleep 1
	done

	echo "init db"
	mysql --socket=/run/mysqld/mysqld.sock << EOF
	CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
	CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
	GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
	FLUSH PRIVILEGES;
EOF

	echo "db created"

	kill $MYSQL_PID
	wait $MYSQL_PID 2>/dev/null || true
fi
	echo "start mariadb"
	exec "$@"
