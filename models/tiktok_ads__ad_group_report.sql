with adapter as (

    select *
    from {{ ref('tiktok_ads__ad_adapter') }}

), ad_groups as (

    select *
    from {{ ref('int_tiktok_ads__most_recent_ad_group') }}

), aggregated as (

    select
        adapter.date_day,
        adapter.ad_group_id,
        adapter.advertiser_id,
        adapter.campaign_id,
        adapter.campaign_name,
        ad_groups.action_categories,
        ad_groups.gender, 
        ad_groups.audience_type,
        ad_groups.budget,
        ad_groups.age, 
        ad_groups.languages, 
        ad_groups.interest_category,
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
    left join ad_groups 
    on adapter.ad_group_id = ad_groups.ad_group_id

    {{ dbt_utils.group_by(12) }}

)

select *
from aggregated