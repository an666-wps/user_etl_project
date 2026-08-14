USE user_dw;
INSERT OVERWRITE TABLE dws_user_behavior
PARTITION(dt='${date}')
SELECT 

SUM(CASE WHEN action='login'THEN 1 ELSE 0 END)
AS login_count,


SUM(CASE WHEN action='buy' THEN 1 ELSE 0 END)
AS buy_count,


SUM(CASE WHEN action='view' THEN 1 ELSE 0 END)
AS view_count,


COUNT(DISTINCT CASE
WHEN action='buy'
THEN user_id
END)
AS buyer_count
FROM user_dw.dwd_user_behavior_detail
WHERE dt='${date}';
