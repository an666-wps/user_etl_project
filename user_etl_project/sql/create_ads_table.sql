USE user_dw;

CREATE TABLE IF NOT EXISTS ads_user_behavior_report
(
    dau int,
    login_count int,
    buy_count int,
    buyer_count int,
    view_count int
)
PARTITIONED BY
(
    dt string
);