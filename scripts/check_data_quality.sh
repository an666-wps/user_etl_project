#!/bin/bash

# ==========================================
# Hive ETL 数据质量检查
# 检查 DWD / DWS / ADS 数据是否正常生成
# ==========================================


if [ -z "$1" ]; then
    date=$(date +%F)
else
    date=$1
fi


HIVE_CONTAINER="hive_server"
HIVE_DB="user_dw"


echo "=========================================="
echo "${date} data quality check start"
echo "=========================================="


# ==========================================
# 1. 检查DWD数据
# ==========================================

dwd_count=$(docker exec $HIVE_CONTAINER \
beeline -u jdbc:hive2://localhost:10000 -n root \
--silent=true --showHeader=false --outputformat=csv2 \
-e "
USE ${HIVE_DB};
SELECT COUNT(*)
FROM dwd_user_behavior_detail
WHERE dt='${date}';
" | tail -1)


if [ "$dwd_count" -eq 0 ]; then
    echo "[ERROR] DWD data is empty"
    exit 1
else
    echo "[SUCCESS] DWD count=${dwd_count}"
fi



# ==========================================
# 2. 检查DWS数据
# ==========================================

dws_count=$(docker exec $HIVE_CONTAINER \
beeline -u jdbc:hive2://localhost:10000 -n root \
--silent=true --showHeader=false --outputformat=csv2 \
-e "
USE ${HIVE_DB};
SELECT COUNT(*)
FROM dws_user_behavior
WHERE dt='${date}';
" | tail -1)


if [ "$dws_count" -eq 0 ]; then
    echo "[ERROR] DWS data is empty"
    exit 1
else
    echo "[SUCCESS] DWS count=${dws_count}"
fi



# ==========================================
# 3. 检查ADS数据
# ==========================================

ads_count=$(docker exec $HIVE_CONTAINER \
beeline -u jdbc:hive2://localhost:10000 -n root \
--silent=true --showHeader=false --outputformat=csv2 \
-e "
USE ${HIVE_DB};
SELECT COUNT(*)
FROM ads_user_behavior_report
WHERE dt='${date}';
" | tail -1)


if [ "$ads_count" -eq 0 ]; then
    echo "[ERROR] ADS data is empty"
    exit 1
else
    echo "[SUCCESS] ADS count=${ads_count}"
fi



echo "=========================================="
echo "${date} data quality check success"
echo "=========================================="

exit 0