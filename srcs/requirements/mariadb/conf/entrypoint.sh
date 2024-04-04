#!/bin/bash

# Start MariaDB service
service mysql start;

# Wait for MariaDB to be ready
while ! mysqladmin ping -h"localhost" --silent; do
    sleep 1
done

# Create database and user
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Stop MariaDB
mysqladmin -u root -p $SQL_ROOT_PASSWORD shutdown

# Start MariaDB in safe mode
exec mysqld_safe