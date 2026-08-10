#!/bin/bash

BASE_DIR=$(cd $(dirname $0)/.. && pwd)

date=$(date +%F)


echo "${date} daily ETL start" >> ${BASE_DIR}/logs/cron_run.log


bash ${BASE_DIR}/scripts/user_behavior_etl.sh ${date}


echo "${date} daily ETL finish" >> ${BASE_DIR}/logs/cron_run.log