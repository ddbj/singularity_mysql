#!/bin/sh

# 本スクリプトの場所をMYSQL_HOMEに設定して~/.my.cnfを参照しないようにする。
export MYSQL_HOME=$(cd $(dirname $0); pwd)

/usr/local/mysql/bin/mysqld --defaults-file=/usr/local/mysql/my_mysql.cnf > /usr/local/mysql/data/mysql.log 2>&1 &

