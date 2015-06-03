#!/bin/bash
FILE=""
DIR="/var/lib/mysql"
# init
# look for empty dir 
if [ "$(ls -A $DIR)" ]; then
    echo "There is data. Make chown mysql:mysql";
    chown -R mysql:mysql /var/lib/mysql
    chown -R mysql:mysql /usr/share/mysql
else
    mysql_install_db > /dev/null
    mysqld_safe &

    echo 'Waiting for mysqld to come online'
    while [ ! -x /var/run/mysqld/mysqld.sock ]; do
        sleep 1
    done
    
    echo 'Setting root password to root'
    /usr/bin/mysqladmin -u root password 'root'  
    echo 'Shutting down mysqld'
    mysqladmin -uroot -proot shutdown
fi
echo "Starting daemon"
mysqld_safe
