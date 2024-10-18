{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true)) }}

with hourly as (
    
    select *
    from {{ var('ad_report_hourly') }}
), 

ads as (

    select *
    from {{ var('ad_history') }}
    where is_most_recent_record
), 

ad_groups as (

    select *
    from {{ var('ad_group_history') }}
    where is_most_recent_record
), 

advertiser as (

    select *
    from {{ var('advertiser') }}
), 

campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record
), 

aggregated as (

    select
        hourly.source_relation,
        cast(hourly.stat_time_hour as date) as date_day,
        ad_groups.advertiser_id,
        advertiser.advertiser_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        hourly.ad_id,
        ads.ad_name,
        ads.base_url,
        ads.url_host,
        ads.url_path,
        ads.utm_source,
        ads.utm_medium,
        ads.utm_campaign,
        ads.utm_content,
        ads.utm_term,
        advertiser.currency,
        ad_groups.category,
        ad_groups.gender,
        ad_groups.audience_type,
        ad_groups.budget,
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
    left join ad_groups 
        on ads.ad_group_id = ad_groups.ad_group_id
        and ads.source_relation = ad_groups.source_relation
    left join advertiser
        on ads.advertiser_id = advertiser.advertiser_id
        and ads.source_relation = advertiser.source_relation
    left join campaigns
        on ads.campaign_id = campaigns.campaign_id
        and ads.source_relation = campaigns.source_relation

    {% if var('ad_reporting__url_report__using_null_filter', True) %}
        -- We are filtering for only ads where url fields are populated.
        where ads.landing_page_url is not null
    {% endif %}

    {{ dbt_utils.group_by(23) }}

)

select *
from aggregated