# 用户行为数据离线ETL项目

## 项目简介

基于 Linux + Shell + Hive 构建用户行为日志离线分析流程，
模拟电商用户行为数据处理过程，实现从原始日志数据、
DWD明细层、DWS汇总层到ADS报表层的数据仓库建设流程。

项目实现了用户行为数据的清洗、转换、统计分析以及自动化调度，
完成一个小型离线数据仓库ETL链路。


## 技术栈

- Linux
- Shell
- Hive
- SQL
- Docker
- Hadoop生态
- Crontab


# 项目架构

```
用户行为日志数据
(user_behavior.csv)

        |
        ↓

Shell ETL处理
(数据清洗、统计、任务调度)

        |
        ↓

DWD明细层
dwd_user_behavior_detail

        |
        ↓

DWS汇总层
dws_user_behavior

        |
        ↓

ADS应用层
ads_user_behavior_report

        |
        ↓

用户行为分析指标
```

---

# 项目目录结构

```
user_etl_project

├── data
│   └── 用户行为原始日志数据
│
├── dwd
│   └── 用户行为明细数据
│
├── result
│   └── ETL任务生成结果
│
├── logs
│   ├── job.log
│   └── cron_run.log
│
├── scripts
│   ├── clean_user_behavior.sh
│   ├── user_behavior_etl.sh
│   └── run_daily_etl.sh
│
├── sql
│   ├── create_dwd_table.sql
│   ├── create_dws_table.sql
│   ├── dws_user_behavior.sql
│   └── ads_user_behavior.sql
│
└── README.md
```


# 数据仓库分层设计


## 1. DWD明细层

### 表名

```
dwd_user_behavior_detail
```

### 功能

存储用户行为明细数据，
保存用户每一次行为记录。


### 字段

|字段|说明|
|-|-|
|user_id|用户ID|
|event_time|行为时间|
|action|行为类型|
|dt|日期分区|


支持按照日期进行分区管理：

```
dt=2026-08-10
```


---

## 2. DWS汇总层


### 表名

```
dws_user_behavior
```


### 功能

按照用户粒度进行行为统计。


### 统计指标

|指标|说明|
|-|-|
|login_count|登录次数|
|view_count|浏览次数|
|buy_count|购买次数|
|user_id|用户ID|



---

## 3. ADS报表层


### 表名

```
ads_user_behavior_report
```


### 功能

生成用户行为分析结果，
提供业务统计指标。


### 指标

|指标|说明|
|-|-|
|dau|日活用户数|
|login_count|登录次数|
|buy_count|购买次数|
|buyer_count|购买用户数|



# 项目功能


## 1. 用户行为日志处理

实现：

- 用户行为日志读取
- 数据格式规范化
- 日期分区管理
- 数据结果输出


## 2. Shell ETL任务

通过Shell脚本完成：

- 数据清洗
- 用户行为统计
- ETL流程自动执行
- 任务日志记录


## 3. Hive数据仓库建设

完成：

- Hive数据库创建
- DWD明细表设计
- DWS统计表设计
- ADS指标报表设计


## 4. 自动化调度


使用Crontab实现定时任务：

例如：

```
0 1 * * *
```

每天凌晨执行ETL任务。


# 环境部署


## 启动Hive环境


进入Hive目录：

```bash
cd hive_env
```


启动Docker容器：

```bash
docker compose up -d
```


进入Hive容器：

```bash
docker exec -it hive_server bash
```


连接Hive：

```bash
beeline -u jdbc:hive2://localhost:10000
```



# ETL任务运行


进入项目目录：

```bash
cd user_etl_project
```


执行每日ETL：

```bash
bash scripts/run_daily_etl.sh 2026-08-10
```



# 查看结果


进入Hive：

```sql
use user_dw;
```


查询ADS结果：

```sql
select * 
from ads_user_behavior_report;
```


示例结果：

|dau|login_count|buy_count|buyer_count|dt|
|-|-|-|-|-|
|3|2|3|3|2026-08-10|



# 项目成果


完成用户行为离线数仓ETL项目建设：

- 实现Shell自动化ETL流程
- 完成Hive数据仓库分层设计
- 建立DWD、DWS、ADS三层数据链路
- 实现Hive分区表管理
- 使用Crontab完成任务调度
- 完成用户行为指标统计分析



# 后续优化方向

- 使用Spark替代Shell完成数据处理
- 引入Kafka实现实时数据采集
- 增加数据质量检测
- 增加用户行为分析Agent，实现自然语言查询数据指标