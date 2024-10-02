{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_hourly_source as (

    select  
        sum(coalesce(total_purchase_value, 0)) + sum(coalesce(total_sales_lead_value, 0)) as total_value,
        sum(coalesce(conversion, 0)) as conversions,
        sum(coalesce(real_time_conversion, 0)) as real_time_conversions
    from {{ source('tiktok_ads', 'ad_report_hourly') }}
),

ad_model as (

    select 
        sum(coalesce(total_conversion_value, 0)) as total_value,
        sum(coalesce(conversion, 0)) as conversions,
        sum(coalesce(real_time_conversion, 0)) as real_time_conversions
    from {{ ref('tiktok_ads__ad_report') }}
),

ad_group_hourly_source as (

    select 
        sum(coalesce(total_purchase_value, 0)) + sum(coalesce(total_sales_lead_value, 0)) as total_value,
        sum(coalesce(conversion, 0)) as conversions,
        sum(coalesce(real_time_conversion, 0)) as real_time_conversions
    from {{ source('tiktok_ads', 'adgroup_report_hourly') }}
),

ad_group_model as (

    select 
        sum(coalesce(total_conversion_value, 0)) as total_value,
        sum(coalesce(conversion, 0)) as conversions,
        sum(coalesce(real_time_conversion, 0)) as real_time_conversions
    from {{ ref('tiktok_ads__ad_group_report') }}
),

campaign_hourly_source as (

    select 
        sum(coalesce(total_purchase_value, 0)) + sum(coalesce(total_sales_lead_value, 0)) as total_value,
        sum(coalesce(conversion, 0)) as conversions,
        sum(coalesce(real_time_conversion, 0)) as real_time_conversions
    from {{ source('tiktok_ads', 'campaign_report_hourly') }}
),

campaign_model as (

    select 
        sum(coalesce(total_conversion_value, 0)) as total_value,
        sum(coalesce(conversion, 0)) as conversions,
        sum(coalesce(real_time_conversion, 0)) as real_time_conversions
    from {{ ref('tiktok_ads__campaign_report') }}
) 

select 
    'ads' as comparison
from ad_model 
join ad_hourly_source on true
where abs(ad_model.total_value - ad_hourly_source.total_value) >= .01
    or abs(ad_model.conversions - ad_hourly_source.conversions) >= .01
    or abs(ad_model.real_time_conversions - ad_hourly_source.real_time_conversions) >= .01

union all 

select 
    'ad_groups' as comparison
from ad_group_model 
join ad_group_hourly_source on true
where abs(ad_group_model.total_value - ad_group_hourly_source.total_value) >= .01
    or abs(ad_group_model.conversions - ad_group_hourly_source.conversions) >= .01
    or abs(ad_group_model.real_time_conversions - ad_group_hourly_source.real_time_conversions) >= .01

union all 

select 
    'campaigns' as comparison
from campaign_model 
join campaign_hourly_source on true
where abs(campaign_model.total_value - campaign_hourly_source.total_value) >= .01
    or abs(campaign_model.conversions - campaign_hourly_source.conversions) >= .01
    or abs(campaign_model.real_time_conversions - campaign_hourly_source.real_time_conversions) >= .01