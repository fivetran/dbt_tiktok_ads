{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true)) }}

with hourly as (
    
    select *
    from {{ var('ad_report_hourly') }}
),

advertiser as (

    select *
    from {{ var('advertiser') }}
), 

ads as (

    select *
    from {{ var('ad_history') }}
    where is_most_recent_record
), 

joined as (

    select
        hourly.source_relation,
        cast(hourly.stat_time_hour as date) as date_day,
        ads.advertiser_id,
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
        sum(hourly.video_views_p_75) as video_views_p_75,
        sum(hourly.real_time_conversion) as real_time_conversion,
        sum(hourly.total_purchase_value) as total_purchase_value,
        sum(hourly.total_sales_lead_value) as total_sales_lead_value,
        sum(hourly.total_purchase_value + hourly.total_sales_lead_value) as total_conversion_value,
        sum(hourly.spend)/nullif(sum(hourly.clicks),0) as daily_cpc,
        (sum(hourly.spend)/nullif(sum(hourly.impressions),0))*1000 as daily_cpm,
        (sum(hourly.clicks)/nullif(sum(hourly.impressions),0))*100 as daily_ctr

        {{ tiktok_ads_persist_pass_through_columns(pass_through_variable='tiktok_ads__ad_hourly_passthrough_metrics', identifier='hourly', transform='sum', coalesce_with=0, exclude_fields=['real_time_conversion','total_purchase_value','total_sales_lead_value']) }}        

    from hourly
    left join ads
        on hourly.ad_id = ads.ad_id
        and hourly.source_relation = ads.source_relation
    left join advertiser
        on ads.advertiser_id = advertiser.advertiser_id
        and ads.source_relation = advertiser.source_relation
    {{ dbt_utils.group_by(5) }}

)

select *
from joined