CREATE TABLE dwd_user_behavior
(
    user_id STRING,
    event_time STRING,
    action STRING,
    item_id STRING
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
