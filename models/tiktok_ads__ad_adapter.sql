
with audience as (

    select *
    from {{ var('') }} 

), campaigns as (

    select *
    from {{ ref('int_tiktok_ads__most_recent_campaign') }}

), ad_groups as (

    select *
    from {{ ref('int_tiktok_ads__most_recent_ad_group') }}

), hourly as (

    select * 
    from {{ ref('')}}   

), joined as (

    select 
        cast(hourly.stat_time_hour as date) as date_day,
        ad_groups.advertiser_id as account_id,
        ad_account_name,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        ad_id,
        ad_name,
        creative_id,
        creative_name,
        ad_groups.base_url,
        ad_groups.url_host,
        ad_groups.url_path,
        ad_groups.utm_source,
        ad_groups.utm_medium,
        ad_groups.utm_campaign,
        ad_groups.utm_content,
        ad_groups.utm_term,
        sum(spend) as spend,
        sum(clicks) as clicks,
        sum(impressions) as impressions
    from 
    left join 
    left join 
    left join 
    {{ dbt_utils.group_by(19) }}


)

select *
from joined