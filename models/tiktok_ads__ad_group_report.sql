with adapter as (

    select *
    from {{ ref('tiktok_ads__ad_adapter') }}

), ad_group_daily as ( --Why don't we use hourly here? I would imagine using the hourly grain like you did in the ad adapter would work.

    select * 
    from {{ ref('stg_tiktok_ads__ad_group_report_daily')}}

), aggregated as (

    select
        adapter.date_day,
        adapter.ad_group_id,
        adapter.advertiser_id,
        adapter.campaign_id,
        adapter.campaign_name,
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

    from adapter
    left join ad_group_daily
    on adapter.ad_group_id = ad_group_daily.ad_group_id
    and adapter.date_day = cast(ad_group_daily.stat_time_day as date) 

    {{ dbt_utils.group_by(5) }}

)

select *
from aggregated