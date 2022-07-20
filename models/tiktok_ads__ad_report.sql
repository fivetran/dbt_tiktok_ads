with hourly as (
    
    select *
    from {{ var('ad_report_hourly') }}

), ads as (

    select *
    from {{ ref('int_tiktok_ads__most_recent_ad') }}

), ad_groups as (

    select *
    from {{ ref('int_tiktok_ads__most_recent_ad_group') }}

), advertiser as (

    select *
    from {{ var('advertiser') }}

), campaigns as (

    select *
    from {{ ref('int_tiktok_ads__most_recent_campaign') }}

), aggregated as (

    select
        cast(hourly.stat_time_hour as date) as date_day,
        ad_groups.advertiser_id,
        advertiser.advertiser_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        ads.ad_id,
        ads.ad_name,
        advertiser.currency,
        ad_groups.category,
        ad_groups.action_categories,
        ad_groups.gender,
        ad_groups.audience_type,
        ad_groups.budget,
        ad_groups.age,
        ad_groups.languages,
        ad_groups.interest_category,
        sum(hourly.impressions) as impressions,
        sum(hourly.clicks) as clicks,
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
        sum(hourly.video_views_p_75) as video_views_p_75,
        sum(hourly.spend)/nullif(sum(hourly.clicks),0) as daily_cpc,
        (sum(hourly.spend)/nullif(sum(hourly.impressions),0))*1000 as daily_cpm,
        (sum(hourly.clicks)/nullif(sum(hourly.impressions),0))*100 as daily_ctr
        
        {% for metric in var('tiktok_ads__ad_hourly_passthrough_metrics', []) %}
        , {{ metric }}
        {% endfor %}
    from hourly
    left join ads
        on hourly.ad_id = ads.ad_id
    left join ad_groups 
        on ads.ad_group_id = ad_groups.ad_group_id
    left join advertiser
        on ads.advertiser_id = advertiser.advertiser_id
    left join campaigns
        on ads.campaign_id = campaigns.campaign_id
    {{ dbt_utils.group_by(18) }}

)

select *
from aggregated