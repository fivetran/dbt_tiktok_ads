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
        round(sum(adapter.spend)/nullifzero(sum(adapter.clicks)),2) as daily_cpc,
        round((sum(adapter.spend)/nullifzero(sum(adapter.impressions)))*1000,2) as daily_cpm,
        round((sum(adapter.clicks)/nullifzero(sum(adapter.impressions)))*100,2) as daily_ctr

    from adapter

    {{ dbt_utils.group_by(4) }}

)

select *
from aggregated