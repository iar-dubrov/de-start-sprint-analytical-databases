drop table if exists VT260909EE3191__DWH.l_user_group_activity;

create table VT260909EE3191__DWH.l_user_group_activity
(
    hk_l_user_group_activity int primary key,
    hk_user_id  int not null CONSTRAINT fk_luga_user  REFERENCES VT260909EE3191__DWH.h_users (hk_user_id),
    hk_group_id int not null CONSTRAINT fk_luga_group REFERENCES VT260909EE3191__DWH.h_groups (hk_group_id),
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_l_user_group_activity all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
