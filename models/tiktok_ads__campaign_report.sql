with adapter as (

    select *
    from {{ ref('tiktok_ads__ad_adapter') }}

), campaign_daily as (

    select * 
    from {{ ref('stg_tiktok_ads__campaign_report_daily')}}

), aggregated as (

    select
        adapter.date_day,
        adapter.advertiser_id,
        -- as ad_account_id
        -- as ad_account_name,
        adapter.campaign_id,
        adapter.campaign_name,
        sum(campaign_daily.impressions) as impressions,
        sum(campaign_daily.clicks) as clicks,
        sum(campaign_daily.spend) as spend,
        sum(campaign_daily.likes) as likes,
        sum(campaign_daily.shares) as shares,
        sum(campaign_daily.profile_visits) as profile_visits,
        sum(campaign_daily.follows) as follows,
        sum(campaign_daily.engagements) as engagements,
        sum(campaign_daily.skip_ad) as skip_ad,
        sum(campaign_daily.video_watched_2s),
        sum(campaign_daily.video_watched_6s),
        sum(campaign_daily.video_views_p25), 
        sum(campaign_daily.video_views_p50), 
        sum(campaign_daily.video_views_p75), 
        sum(campaign_daily.average_video_play), 
        sum(campaign_daily.average_video_play_per_user)

    from adapter
    left join campaign_daily
    on adapter.campaign_id = campaign_daily.campaign_id
    and adapter.date_day = cast(campaign_daily.stat_time_day as date) 

    {{ dbt_utils.group_by(6) }}

)

select *
from aggregated