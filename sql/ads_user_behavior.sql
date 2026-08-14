USE user_dw;

INSERT OVERWRITE TABLE ads_user_behavior_report
PARTITION(dt='${date}')
SELECT
    (
        SELECT COUNT(DISTINCT user_id)
        FROM user_dw.dwd_user_behavior_detail
        WHERE dt='${date}'
    ) AS dau,
    login_count,
    buy_count,
    buyer_count,
    view_count
FROM user_dw.dws_user_behavior
WHERE dt='${date}';
