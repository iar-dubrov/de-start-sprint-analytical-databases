with user_group_messages as (
    select
        lgd.hk_group_id,
        count(distinct lum.hk_user_id) as cnt_users_in_group_with_messages
    from VT260909EE3191__DWH.l_groups_dialogs as lgd
    inner join VT260909EE3191__DWH.l_user_message as lum on lgd.hk_message_id = lum.hk_message_id
    group by lgd.hk_group_id
)
select hk_group_id, cnt_users_in_group_with_messages
from user_group_messages
order by cnt_users_in_group_with_messages
limit 10;
