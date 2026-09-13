drop table if exists VT260909EE3191__STAGING.group_log;

create table VT260909EE3191__STAGING.group_log
(
    group_id      int,
    user_id       int,
    user_id_from  int,
    event         varchar(20),
    "datetime"    timestamp
)
order by group_id
SEGMENTED BY hash(group_id, user_id) all nodes;
