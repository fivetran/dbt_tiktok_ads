with adapter as (

    select *
    from {{ ref('') }}

), aggregated as (

    select
        date_day,
        ad_account_id,
        ad_account_name,
        campaign_id,
        campaign_name,
        sum(impressions) as impressions,
        sum(spend) as spend
    from adapter
    {{ dbt_utils.group_by(5) }}

)

select *
from aggregated