{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_report as (

    select 
        sum(conversion) as total_conversions,
        sum(total_conversion_value) as total_value,
        sum(real_time_conversion) as total_real_time_conversions
    from {{ ref('tiktok_ads__ad_report') }}
),

advertiser_report as (

    select 
        sum(conversion) as total_conversions,
        sum(total_conversion_value) as total_value,
        sum(real_time_conversion) as total_real_time_conversions
    from {{ ref('tiktok_ads__advertiser_report') }}
),

ad_group_report as (

    select 
        sum(conversion) as total_conversions,
        sum(total_conversion_value) as total_value,
        sum(real_time_conversion) as total_real_time_conversions
    from {{ ref('tiktok_ads__ad_group_report') }}
),

campaign_report as (

    select 
        sum(conversion) as total_conversions,
        sum(total_conversion_value) as total_value,
        sum(real_time_conversion) as total_real_time_conversions
    from {{ ref('tiktok_ads__campaign_report') }}
),

url_report as (

    select 
        sum(conversion) as total_conversions,
        sum(total_conversion_value) as total_value,
        sum(real_time_conversion) as total_real_time_conversions
    from {{ ref('tiktok_ads__url_report') }}
),

ad_w_url_report as (

    select 
        sum(conversion) as total_conversions,
        sum(total_conversion_value) as total_value,
        sum(real_time_conversion) as total_real_time_conversions
    from {{ ref('tiktok_ads__ad_report') }} ads
    join {{ ref('tiktok_ads__url_report') }} urls
        on ads.ad_id = urls.ad_id
        and ads.date_day = urls.date_day
), 

select 
    'ad vs advertiser' as comparison
from ad_report 
join advertiser_report on true
where ad_report.total_value != advertiser_report.total_value
    or ad_report.total_conversions != advertiser_report.total_conversions
    or ad_report.total_real_time_conversions != advertiser_report.total_real_time_conversions

union all 

select 
    'ad vs ad group' as comparison
from ad_report 
join ad_group_report on true
where ad_report.total_value != ad_group_report.total_value
    or ad_report.total_conversions != ad_group_report.total_conversions
    or ad_report.total_real_time_conversions != ad_group_report.total_real_time_conversions

union all 

select 
    'ad vs campaign' as comparison
from ad_report 
join campaign_report on true
where ad_report.total_value != campaign_report.total_value
    or ad_report.total_conversions != campaign_report.total_conversions
    or ad_report.total_real_time_conversions != campaign_report.total_real_time_conversions

union all 

select 
    'ad vs url' as comparison
from ad_w_url_report 
join url_report on true
where ad_w_url_report.total_value != url_report.total_value
    or ad_w_url_report.total_conversions != url_report.total_conversions
    or ad_w_url_report.total_real_time_conversions != url_report.total_real_time_conversions