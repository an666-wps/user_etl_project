#!/bin/bash

# ==============================
# 日期参数
# ==============================

if [ -z "$1" ]; then
    date=$(date +%F)
else
    date=$1
fi


# ==============================
# 项目根目录
# ==============================

BASE_DIR=$(cd $(dirname $0)/.. && pwd)


# ==============================
# 路径
# ==============================

log_file="${BASE_DIR}/logs/job.log"

result_dir="${BASE_DIR}/result/dt=${date}"

result_file="${result_dir}/user_behavior_report.csv"

data_file="${BASE_DIR}/dwd/user_behavior_detail/dt=${date}/user_behavior_detail.csv"


# ==============================
# 检查数据
# ==============================

if [ ! -f "$data_file" ]; then

    echo "${date} data file not exist: ${data_file}" >> "$log_file"

    exit 1

fi


# ==============================
# 开始任务
# ==============================

echo "${date} ETL start" >> "$log_file"


# ==============================
# 数据统计
# ==============================

login_count=$(grep -w login "$data_file" | wc -l)

buyer_count=$(grep -w buy "$data_file" \
| awk -F',' '{print $1}' \
| sort \
| uniq \
| wc -l)


dau_count=$(grep -w login "$data_file" \
| awk -F',' '{print $1}' \
| sort \
| uniq \
| wc -l)


buy_count=$(grep -w buy "$data_file" | wc -l)


view_count=$(grep -w view "$data_file" | wc -l)



# ==============================
# 输出结果
# ==============================

mkdir -p "$result_dir"


echo "date,login_count,dau_count,buy_count,view_count,buyer_count" \
> "$result_file"


echo "${date},${login_count},${dau_count},${buy_count},${view_count},${buyer_count}" \
>> "$result_file"



# ==============================
# 写日志
# ==============================

echo "date=${date}" >> "$log_file"

echo "login_count=${login_count}" >> "$log_file"

echo "dau_count=${dau_count}" >> "$log_file"

echo "buy_count=${buy_count}" >> "$log_file"

echo "view_count=${view_count}" >> "$log_file"

echo "buyer_count=${buyer_count}" >> "$log_file"



# ==============================
# 结束
# ==============================

echo "${date} ETL finish" >> "$log_file"