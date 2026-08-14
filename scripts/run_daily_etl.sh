#!/bin/bash

# ==========================================
# 用户行为数据每日 Hive ETL 主流程
# DWD -> DWS -> ADS
# ==========================================

# 日期参数
if [ -z "$1" ]; then
    date=$(date +%F)
else
    date=$1
fi

# 项目根目录
BASE_DIR=$(cd "$(dirname "$0")/.." && pwd)

# 日志文件
LOG_FILE="${BASE_DIR}/logs/cron_run.log"

# Hive 容器
HIVE_CONTAINER="hive_server"

# Hive 数据库
HIVE_DB="user_dw"

# ==========================================
# 日志函数
# ==========================================

log() {
    echo "$(date '+%F %T') $1" >> "$LOG_FILE"
}

# ==========================================
# 开始
# ==========================================

log "=========================================="
log "${date} daily Hive ETL start"

# ==========================================
# 1. 生成当天 DWD 数据
# ==========================================

log "${date} generating DWD data"

bash "${BASE_DIR}/scripts/generate_daily_data.sh" "$date"

if [ $? -ne 0 ]; then
    log "${date} DWD data generation failed"
    exit 1
fi

# ==========================================
# 2. 清理 Hive 当天 DWD 分区
# 防止重复执行导致数据重复
# ==========================================

log "${date} cleaning Hive DWD partition"

docker exec "$HIVE_CONTAINER" \
    beeline -u jdbc:hive2://localhost:10000 -n root \
    -e "USE ${HIVE_DB};
        ALTER TABLE dwd_user_behavior_detail
        DROP IF EXISTS PARTITION(dt='${date}');"

if [ $? -ne 0 ]; then
    log "${date} DWD partition cleanup failed"
    exit 1
fi

# ==========================================
# 3. 将 DWD CSV 复制到 Hive 容器
# ==========================================

DATA_FILE="${BASE_DIR}/dwd/user_behavior_detail/dt=${date}/user_behavior_detail.csv"

log "${date} copying DWD data to Hive container"

docker cp "$DATA_FILE" \
    "${HIVE_CONTAINER}:/tmp/user_behavior_detail_${date}.csv"

if [ $? -ne 0 ]; then
    log "${date} DWD data copy failed"
    exit 1
fi

# ==========================================
# 4. 导入 Hive DWD
# ==========================================

log "${date} loading data into Hive DWD"

docker exec "$HIVE_CONTAINER" \
    beeline -u jdbc:hive2://localhost:10000 -n root \
    -e "USE ${HIVE_DB};
        LOAD DATA LOCAL INPATH
        '/tmp/user_behavior_detail_${date}.csv'
        INTO TABLE dwd_user_behavior_detail
        PARTITION(dt='${date}');"

if [ $? -ne 0 ]; then
    log "${date} DWD load failed"
    exit 1
fi

# ==========================================
# 5. 执行 DWS
# ==========================================

log "${date} starting DWS"

docker cp \
    "${BASE_DIR}/sql/dws_user_behavior.sql" \
    "${HIVE_CONTAINER}:/tmp/dws_user_behavior.sql"

docker exec "$HIVE_CONTAINER" \
    beeline -u jdbc:hive2://localhost:10000 -n root \
    --hivevar date="${date}" \
    -f /tmp/dws_user_behavior.sql

if [ $? -ne 0 ]; then
    log "${date} DWS failed"
    exit 1
fi

# ==========================================
# 6. 执行 ADS
# ==========================================

log "${date} starting ADS"

docker cp \
    "${BASE_DIR}/sql/ads_user_behavior.sql" \
    "${HIVE_CONTAINER}:/tmp/ads_user_behavior.sql"

docker exec "$HIVE_CONTAINER" \
    beeline -u jdbc:hive2://localhost:10000 -n root \
    --hivevar date="${date}" \
    -f /tmp/ads_user_behavior.sql

if [ $? -ne 0 ]; then
    log "${date} ADS failed"
    exit 1
fi

# ==========================================
# 7. 完成
# ==========================================

log "${date} daily Hive ETL finish"

exit 0