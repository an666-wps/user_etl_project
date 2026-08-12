CREATE TABLE dws_user_behavior
(
    user_id string,
    login_count int,
    buy_count int,
    view_count int,
    buyer_count int
)
PARTITIONED BY
(
    dt string
);