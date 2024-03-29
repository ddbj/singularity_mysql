#!/bin/bash

CONTAINER_HOME=$(cd $(dirname $0); pwd)
IMAGE="ubuntu-18.04-mysql-5.6.46.simg"
INSTANCE="mysql"

if [ ! -e ${CONTAINER_HOME}/mysql_data ]; then
    mkdir ${CONTAINER_HOME}/mysql_data
fi

singularity instance start \
-B ${CONTAINER_HOME}/mysql_data:/usr/local/mysql/data \
-B ${CONTAINER_HOME}/my_mysql.cnf:/usr/local/mysql/my_mysql.cnf \
-H ${CONTAINER_HOME}/mysql_data \
${CONTAINER_HOME}/${IMAGE} \
${INSTANCE}

singularity exec instance://${INSTANCE} ${CONTAINER_HOME}/start_mysqld.sh
