{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true)) }}

with hourly as (
    
    select *
    from {{ ref('stg_tiktok_ads__ad_report_hourly') }}
), 

ads as (

    select
        ad_id,
        ad_group_id,
        advertiser_id,
        campaign_id,
        ad_name,
        landing_page_url,
        cast(null as {{ dbt.type_string() }}) as landing_page_urls,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        source_relation
    from {{ ref('stg_tiktok_ads__ad_history') }}
    where is_most_recent_record

    {% if var('tiktok_ads__using_creative_history', true) and var('tiktok_ads__using_smart_plus_ad_history', true) %}
    union all

    -- Smart+ ads resolve via `creative_history`, then join `smart_plus_ad_history` (through
    -- `creative_history.smart_plus_ad_id`) for URL data only, since `creative_history` carries none.
    -- Without `smart_plus_ad_history` there's no URL data to report on, so Smart+ ads are left out here
    -- entirely (they're still included in `tiktok_ads__ad_report`/`tiktok_ads__advertiser_report`).
    select
        creative_history.creative_id as ad_id,
        creative_history.adgroup_id as ad_group_id,
        creative_history.advertiser_id,
        creative_history.campaign_id,
        creative_history.creative_name as ad_name,
        smart_plus_ad_history.landing_page_url,
        smart_plus_ad_history.landing_page_urls,
        smart_plus_ad_history.base_url,
        smart_plus_ad_history.url_host,
        smart_plus_ad_history.url_path,
        smart_plus_ad_history.utm_source,
        smart_plus_ad_history.utm_medium,
        smart_plus_ad_history.utm_campaign,
        smart_plus_ad_history.utm_content,
        smart_plus_ad_history.utm_term,
        creative_history.source_relation
    from {{ ref('stg_tiktok_ads__creative_history') }} as creative_history
    left join {{ ref('stg_tiktok_ads__smart_plus_ad_history') }} as smart_plus_ad_history
        on creative_history.smart_plus_ad_id = smart_plus_ad_history.smart_plus_ad_id
        and creative_history.source_relation = smart_plus_ad_history.source_relation
        and smart_plus_ad_history.is_most_recent_record
    where creative_history.is_most_recent_record
    {% endif %}

),

ad_groups as (

    select *
    from {{ ref('stg_tiktok_ads__ad_group_history') }}
    where is_most_recent_record
), 

advertiser as (

    select *
    from {{ ref('stg_tiktok_ads__advertiser') }}
), 

campaigns as (

    select *
    from {{ ref('stg_tiktok_ads__campaign_history') }}
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
        ads.landing_page_urls,
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

    {{ dbt_utils.group_by(24) }}

)

select *
from aggregated