#!/bin/bash
set -xe
set -o pipefail

CURRENT_DIR=$(cd $(dirname $0);pwd)
export MYSQL_HOST=${MYSQL_HOSTNAME:-mysql}
export MYSQL_PORT=${MYSQL_PORT:-13306}
export MYSQL_USER=${MYSQL_USER:-isutrain}
export MYSQL_DBNAME=${MYSQL_DATABASE:-isutrain}
export MYSQL_PWD=${MYSQL_PASSWORD:-isutrain}
export LANG="C.UTF-8"
cd $CURRENT_DIR

cat 01_schema.sql 90_train.sql 91_station.sql 93_seat.sql \
94_0_train_timetable.sql 94_1_train_timetable.sql 94_2_train_timetable.sql \
94_3_train_timetable.sql 94_4_train_timetable.sql 94_5_train_timetable.sql \
| mysql --defaults-file=/dev/null -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER $MYSQL_DBNAME
