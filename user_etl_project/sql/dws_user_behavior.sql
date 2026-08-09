INSERT OVERWRITE TABLE dws_user_behavior_day
PARTITION(day='2026-07-15')

SELECT 

SUM(CASE WHEN action='login'THEN 1 ELSE 0 END)
AS login_count,

COUNT(DISTINCT CASE WHEN action='login' THEN user_id END)
AS dau_count

SUM(CASE WHEN action='buy' THEN 1 ELSE 0 END)
AS buy_count,


SUM(CASE WHEN action='view' THEN 1 ELSE 0 END)
AS view_count,


COUNT(DISTINCT CASE
WHEN action='buy'
THEN user_id
END)
AS buyer_count
FROM dwd_user_behavior
WHERE day='2026-07-15';
