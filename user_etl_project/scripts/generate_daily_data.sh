#!/bin/bash

# ===============================
# 模拟每日生成DWD用户行为数据
# ===============================

if [ -z "$1" ]; then
    date=$(date +%F)
else
    date=$1
fi


# 项目根目录
base_dir=$(cd "$(dirname "$0")/.." && pwd)

# DWD目录
dwd_dir="${base_dir}/dwd/user_behavior_detail/dt=${date}"

# 数据文件
data_file="${dwd_dir}/user_behavior_detail.csv"


# 创建目录
mkdir -p "$dwd_dir"


# 生成模拟数据


echo "u001,${date} 08:10:00,login,item001" >> "$data_file"
echo "u001,${date} 08:20:00,view,item001" >> "$data_file"
echo "u001,${date} 09:00:00,buy,item001" >> "$data_file"

echo "u002,${date} 09:30:00,login,item002" >> "$data_file"
echo "u002,${date} 10:00:00,view,item002" >> "$data_file"
echo "u002,${date} 11:00:00,buy,item002" >> "$data_file"

echo "u003,${date} 12:00:00,buy,item003" >> "$data_file"

echo "${date} DWD data generated:"
echo "$data_file"