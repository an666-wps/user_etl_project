#!/bin/bash
if [ -z "$1" ]; then
    date=$(date +%F)
else
    date=$1
fi

data_file="../data/user_log_${date}.txt" #数据来源
dwd_dir="../dwd/user_behavior_detail/dt=${date}"
dwd_file="${dwd_dir}/user_behavior_detail.csv"

# 自动创建多级目录，关键
mkdir -p "$dwd_dir"
# 写入表头
> "$dwd_file"
# 读取日志写入csv，awk语法连贯不换行拆分
awk '{print $1","$2","$3","$4","$5}' "$data_file" >> "$dwd_file"