with adapter as (

    select *
    from {{ ref('tiktok_ads__ad_adapter') }}
    
), aggregated as (

    select
        adapter.date_day,
        adapter.campaign_id,
        adapter.campaign_name,
        adapter.advertiser_id,
        sum(adapter.impressions) as impressions,
        sum(adapter.clicks) as clicks,
        sum(adapter.spend) as spend,
        sum(adapter.reach) as reach,
        sum(adapter.conversion) as conversion,
        sum(adapter.likes) as likes,
        sum(adapter.comments) as comments,
        sum(adapter.shares) as shares,
        sum(adapter.profile_visits) as profile_visits,
        sum(adapter.follows) as follows,
        sum(adapter.video_watched_2_s) as video_watched_2_s,
        sum(adapter.video_watched_6_s) as video_watched_6_s,
        sum(adapter.video_views_p_25) as video_views_p_25,
        sum(adapter.video_views_p_50) as video_views_p_50, 
        sum(adapter.video_views_p_75) as video_views_p_75,
        sum(adapter.spend)/nullif(sum(adapter.clicks),0) as daily_cpc,
        (sum(adapter.spend)/nullif(sum(adapter.impressions),0))*1000 as daily_cpm,
        (sum(adapter.clicks)/nullif(sum(adapter.impressions),0))*100 as daily_ctr

    from adapter

    {{ dbt_utils.group_by(4) }}

)

select *
from aggregated