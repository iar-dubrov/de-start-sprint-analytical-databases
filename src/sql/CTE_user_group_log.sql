with user_group_log as (
    select
        luga.hk_group_id,
        count(distinct luga.hk_user_id) as cnt_added_users
    from VT260909EE3191__DWH.s_auth_history as sah
    inner join VT260909EE3191__DWH.l_user_group_activity as luga
            on sah.hk_l_user_group_activity = luga.hk_l_user_group_activity
    where sah.event = 'add'
      and luga.hk_group_id in (
            select hk_group_id
            from VT260909EE3191__DWH.h_groups
            order by registration_dt
            limit 10)
    group by luga.hk_group_id
)
select hk_group_id, cnt_added_users
from user_group_log
order by cnt_added_users
limit 10;
