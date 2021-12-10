with adapter as (

    select *
    from {{ ref('tiktok_ads__ad_adapter') }}

), campaign_daily as (  --Why do we bring this in? Don't we have all these fields within the tiktok_ads__ad_adapter model already?

    select * 
    from {{ ref('stg_tiktok_ads__campaign_report_daily')}}

), aggregated as (

    select
        adapter.date_day,
        adapter.campaign_id,
        adapter.campaign_name,
        adapter.advertiser_id,
        sum(campaign_daily.impressions) as impressions,
        sum(campaign_daily.clicks) as clicks,
        sum(campaign_daily.spend) as spend,
        sum(campaign_daily.reach) as reach,
        sum(campaign_daily.conversion) as conversion,
        sum(campaign_daily.likes) as likes,
        sum(campaign_daily.comments) as comments,
        sum(campaign_daily.shares) as shares,
        sum(campaign_daily.profile_visits) as profile_visits,
        sum(campaign_daily.follows) as follows,
        sum(campaign_daily.video_watched_2_s) as video_watched_2_s,
        sum(campaign_daily.video_watched_6_s) as video_watched_6_s,
        sum(campaign_daily.video_views_p_25) as video_views_p_25,
        sum(campaign_daily.video_views_p_50) as video_views_p_50, 
        sum(campaign_daily.video_views_p_75) as video_views_p_75

    from adapter
    left join campaign_daily
    on adapter.campaign_id = campaign_daily.campaign_id
    and adapter.date_day = cast(campaign_daily.stat_time_day as date) 

    {{ dbt_utils.group_by(4) }}

)

select *
from aggregated