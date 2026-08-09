CREATE TABLE dwd_user_behavior
(
	dt STRING,
	event_time STRING,
	user_id STRING,
	action STRING,
	item_id STRING
)
PARTITION BY (day STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
