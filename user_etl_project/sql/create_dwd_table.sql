USE user_dw;

DROP TABLE IF EXISTS dwd_user_behavior_detail;

CREATE TABLE dwd_user_behavior_detail
(
    user_id string,
    event_time string,
    action string,
    item_id string
)
PARTITIONED BY
(
    dt string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';