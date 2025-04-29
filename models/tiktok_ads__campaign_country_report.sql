{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true) and var('tiktok_ads__using_campaign_country_report', true)) }}

with country_report as (
    
    select *
    from {{ var('campaign_country_report') }}
), 

campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record
), 

advertiser as (

    select *
    from {{ var('advertiser') }}
), 

aggregated as (

    select
        country_report.source_relation,
        country_report.stat_time_day as date_day,
        country_report.campaign_id,
        campaigns.campaign_name,
        campaigns.campaign_type,
        campaigns.created_at,
        country_report.country_code,
        advertiser.advertiser_id,
        advertiser.advertiser_name,
        advertiser.currency,
        campaigns.objective_type,
        campaigns.status,
        campaigns.split_test_variable,
        campaigns.budget,
        campaigns.budget_mode,
        coalesce(country_report.clicks, 0) as clicks,
        coalesce(country_report.impressions, 0) as impressions,
        coalesce(country_report.spend, 0) as spend,
        coalesce(country_report.conversion, 0) as conversion,
        coalesce(country_report.conversion_rate, 0) as conversion_rate,
        coalesce(country_report.cost_per_conversion, 0) as cost_per_conversion,
        coalesce(country_report.cpc, 0) as daily_cpc,
        coalesce(country_report.cpm, 0) as daily_cpm,
        coalesce(country_report.ctr, 0) as daily_ctr,
        coalesce(country_report.real_time_conversion, 0) as real_time_conversion

        {{ tiktok_ads_persist_pass_through_columns(pass_through_variable='tiktok_ads__campaign_country_report_passthrough_metrics', identifier='country_report', transform='sum', coalesce_with=0) }}        

    from country_report
    left join campaigns
        on country_report.campaign_id = campaigns.campaign_id
        and country_report.source_relation = campaigns.source_relation
    left join advertiser
        on campaigns.advertiser_id = advertiser.advertiser_id
        and campaigns.source_relation = advertiser.source_relation
)

select *
from aggregated