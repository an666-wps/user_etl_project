CREATE TABLE IF NOT EXISTS dws_user_behavior
(
    login_count int,
    buy_count int,
    view_count int,
    buyer_count int
)
PARTITIONED BY
(
    dt string
);