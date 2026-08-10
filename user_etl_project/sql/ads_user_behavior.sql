INSERT OVERWRITE TABLE ads_user_behavior_report
PARTITION(dt='2026-08-10')

SELECT
    COUNT(DISTINCT user_id),
    SUM(login_count),
    SUM(buy_count),
    COUNT(CASE WHEN buy_count > 0 THEN user_id END)

FROM dws_user_behavior

WHERE dt='2026-08-10';