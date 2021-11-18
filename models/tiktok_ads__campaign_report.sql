with adapter as (

    select *
    from {{ ref('') }}

), aggregated as (

    select
        stat_time_day as date_day,
        advertiser_id as ad_account_id,
        as ad_account_name,
        campaign_id,
        campaign_name,
        sum(impressions) as impressions,
        sum(clicks) as clicks,
        sum(spend) as spend,
        sum(likes) as likes,
        sum(comments) as impressions,
        sum(shares) as shares,
        sum(profile_visits) as profile_visits,
        sum(follows) as follows,
        sum(engagements) as engagements,
        sum(skip_ad) as skip_ad,
-- spend,
-- cpm, 
-- cpc,
-- ctr,
-- impressions,
-- clicks,
-- likes,
-- comments,
-- shares,
-- profile_visits,
-- follows,
-- engagements,
-- engagement_rate,
-- skip_ad,
-- video_watched_2s,
-- video_watched_6s,
-- video_views_p25, 
-- video_views_p50, 
-- video_views_p75, 
-- video_views_p100, 
-- average_video_play, 
-- average_video_play_per_user

    from adapter
    {{ dbt_utils.group_by(5) }}

)

select *
from aggregated