#!/bin/sh

/usr/local/mysql/bin/mysqld --defaults-file=/usr/local/mysql/my_mysql.cnf > /usr/local/mysql/data/mysql.log 2>&1 &

