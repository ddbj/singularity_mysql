#!/bin/bash

CONTAINER_HOME="/home/okuda/singularity/ubuntu-18.04-mysql-5.6"
IMAGE="ubuntu-18.04-mysql-5.6.46.simg"
INSTANCE="mysql"

singularity instance.start \
-B ${CONTAINER_HOME}/mysql_data:/usr/local/mysql/data \
-B ${CONTAINER_HOME}/my_mysql.cnf:/usr/local/mysql/my_mysql.cnf \
${IMAGE} \
${INSTANCE}

singularity exec instance://${INSTANCE} ${CONTAINER_HOME}/start_mysqld.sh
