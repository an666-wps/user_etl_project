CREATE TABLE dws_user_behavior_day
(
    login_count INT,
    dau_count INT,
    buy_count INT,
    view_count INT,
    buyer_count INT
)
PARTITIONED BY(day STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
