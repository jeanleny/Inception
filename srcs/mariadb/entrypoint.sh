#!/bin/bash
# ^ tells the OS to run this file with bash

# Stop the script immediately if any command fails
# Without this, the script keeps running even after an error
set -e

# Create the directory where MariaDB puts its socket file
# It doesn't exist by default in the debian:bookworm image
# -p means "create parent directories too, no error if already exists"
mkdir -p /run/mysqld

# Give ownership to the mysql user
# MariaDB runs as mysql (not root) and needs to write here
chown -R mysql:mysql /run/mysqld

# Check if the database has already been initialized
# MariaDB stores all its data in /var/lib/mysql
# The "mysql" subfolder is the internal system database
# It only exists after a first-time setup — so we use it as a flag
if [ ! -d "/var/lib/mysql/mysql" ]; then

    # mysql_install_db sets up the base system tables MariaDB needs to function
    # --user=mysql    → run as the mysql system user (not root) for security
    # --datadir       → where to store all database files
    # > /dev/null     → hide the verbose output, we don't need to see it
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Start MariaDB temporarily in bootstrap mode
    # Bootstrap mode lets us run SQL commands before the server is fully started
    # We pipe our SQL commands directly into it with <<EOF ... EOF
    # This is a "heredoc" — everything between EOF markers is treated as input
    mysqld --user=mysql --bootstrap --bind-address=0.0.0.0 << EOF

-- Use the built-in mysql database to manage users and permissions
USE mysql;

-- Create our wordpress database if it doesn't exist yet
-- IF NOT EXISTS means no error if we run this twice by accident
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

-- Create the wordpress user
-- '$MYSQL_USER'@'%' means: this user can connect from ANY host (% = wildcard)
-- We need % because WordPress is in a DIFFERENT container
-- IDENTIFIED BY sets the password
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

-- Give that user full control over the wordpress database only
-- The *.  means "all tables inside that database"
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

-- Also secure the root account with a password
-- 'root'@'localhost' means root can only connect from inside this container
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

-- Apply all the permission changes we just made
FLUSH PRIVILEGES;

EOF
    echo "Database ready."
fi

# Start MariaDB for real, in the foreground
# --user=mysql  → run as the mysql system user
# exec replaces this bash process with mysqld
# This matters because Docker sends stop signals to process ID 1
# If we don't use exec, bash is PID 1 and mysqld never receives the signal
exec mysqld --user=mysql
