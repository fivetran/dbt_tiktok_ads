with base as (

    select *
    from {{ var('campaign_history') }}

), row_num as (

    select 
        *,
        row_number() over (partition by ad_group_id order by _fivetran_synced desc) as rn
    from base

), filtered as (

    select *
    from row_num
    where rn = 1
    
)

select *
from filtered
