with hourly as (
    
    select *
    from {{ var('ad_report_hourly') }}

), advertiser as (

    select *
    from {{ var('advertiser') }}

), ads as (

    select *
    from {{ ref('int_tiktok_ads__most_recent_ad') }}

), joined as (

    select 
        cast(hourly.stat_time_hour as date) as date_day,
        advertiser.advertiser_id,
        advertiser.advertiser_name,
        advertiser.currency,
        sum(hourly.clicks) as clicks,
        sum(hourly.impressions) as impressions,
        sum(hourly.spend) as spend,
        sum(hourly.reach) as reach,
        sum(hourly.conversion) as conversion,
        sum(hourly.likes) as likes,
        sum(hourly.comments) as comments,
        sum(hourly.shares) as shares,
        sum(hourly.profile_visits) as profile_visits,
        sum(hourly.follows) as follows,
        sum(hourly.video_watched_2_s) as video_watched_2_s, 
        sum(hourly.video_watched_6_s) as video_watched_6_s, 
        sum(hourly.video_views_p_25) as video_views_p_25, 
        sum(hourly.video_views_p_50) as video_views_p_50,
        sum(hourly.video_views_p_75) as video_views_p_75
    from hourly
    left join ads
        on hourly.ad_id = ads.ad_id
    left join advertiser
        on ads.advertiser_id = advertiser.advertiser_id
    {{ dbt_utils.group_by(4) }}
    


)

select *
from joined