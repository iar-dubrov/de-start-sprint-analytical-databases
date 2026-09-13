with user_group_log as (
    select
        luga.hk_group_id,
        count(distinct luga.hk_user_id) as cnt_added_users
    from VT260909EE3191__DWH.s_auth_history as sah
    inner join VT260909EE3191__DWH.l_user_group_activity as luga
            on sah.hk_l_user_group_activity = luga.hk_l_user_group_activity
    where sah.event = 'add'
      and luga.hk_group_id in (
            select hk_group_id from VT260909EE3191__DWH.h_groups order by registration_dt limit 10)
    group by luga.hk_group_id
),
user_group_messages as (
    select
        lgd.hk_group_id,
        count(distinct lum.hk_user_id) as cnt_users_in_group_with_messages
    from VT260909EE3191__DWH.l_groups_dialogs as lgd
    inner join VT260909EE3191__DWH.l_user_message as lum on lgd.hk_message_id = lum.hk_message_id
    where lgd.hk_group_id in (
            select hk_group_id from VT260909EE3191__DWH.h_groups order by registration_dt limit 10)
    group by lgd.hk_group_id
)
select
    ugl.hk_group_id,
    ugl.cnt_added_users,
    ugm.cnt_users_in_group_with_messages,
    coalesce(ugm.cnt_users_in_group_with_messages, 0)::numeric / ugl.cnt_added_users as group_conversion
from user_group_log as ugl
left join user_group_messages as ugm on ugl.hk_group_id = ugm.hk_group_id
order by group_conversion desc;
