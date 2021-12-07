with ad_group_daily as (
    
    select * 
    from {{ ref('stg_tiktok_ads__ad_group_report_daily')}}
    
), ad_group_info as (    
    
    select *
    from {{ ref('int_tiktok_ads__most_recent_ad_group') }}
    
), aggregated as (

    select
        ad_group_daily.ad_group_id,
        ad_group_daily.stat_time_day, 
        ad_group_info.ad_group_name, 
        ad_group_info.advertiser_id, 
        ad_group_info.campaign_id, 
        ad_group_info.action_days,
        ad_group_info.gender, 
        -- ad_group_info.age, 
        -- ad_group_info.languages, 
        -- ad_group_info.interest_category, 
        sum(ad_group_daily.impressions) as impressions,
        sum(ad_group_daily.clicks) as clicks,
        sum(ad_group_daily.spend) as spend,
        sum(ad_group_daily.reach) as reach,
        sum(ad_group_daily.conversion) as conversion,
        sum(ad_group_daily.likes) as likes,
        sum(ad_group_daily.comments) as comments,
        sum(ad_group_daily.shares) as shares,
        sum(ad_group_daily.profile_visits) as profile_visits,
        sum(ad_group_daily.follows) as follows,
        sum(ad_group_daily.video_watched_2_s) as video_watched_2_s,
        sum(ad_group_daily.video_watched_6_s) as video_watched_6_s,
        sum(ad_group_daily.video_views_p_25) as video_views_p_25,
        sum(ad_group_daily.video_views_p_50) as video_views_p_50, 
        sum(ad_group_daily.video_views_p_75) as video_views_p_75

    from ad_group_daily
    left join ad_group_info
    on ad_group_daily.ad_group_id = ad_group_info.ad_group_id

    {{ dbt_utils.group_by(7) }}

)

select *
from aggregated