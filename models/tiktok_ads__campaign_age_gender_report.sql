{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true) and var('tiktok_ads__using_campaign_age_gender_report', true)) }}

with age_gender_report as (

    select *
    from {{ ref('stg_tiktok_ads__campaign_age_gender_report') }}
),

campaigns as (

    select *
    from {{ ref('stg_tiktok_ads__campaign_history') }}
    where is_most_recent_record
),

advertiser as (

    select *
    from {{ ref('stg_tiktok_ads__advertiser') }}
),

aggregated as (

    select
        age_gender_report.source_relation,
        age_gender_report.stat_time_day as date_day,
        age_gender_report.campaign_id,
        campaigns.campaign_name,
        campaigns.campaign_type,
        campaigns.created_at,
        age_gender_report.age,
        age_gender_report.min_age,
        age_gender_report.max_age,
        age_gender_report.gender,
        advertiser.advertiser_id,
        advertiser.advertiser_name,
        advertiser.currency,
        campaigns.objective_type,
        campaigns.status,
        campaigns.split_test_variable,
        campaigns.budget,
        campaigns.budget_mode,
        sum(age_gender_report.clicks) as clicks,
        sum(age_gender_report.impressions) as impressions,
        sum(age_gender_report.spend) as spend,
        sum(age_gender_report.conversion) as conversion,
        sum(age_gender_report.spend)/nullif(sum(age_gender_report.clicks),0) as daily_cpc,
        (sum(age_gender_report.spend)/nullif(sum(age_gender_report.impressions),0))*1000 as daily_cpm,
        (sum(age_gender_report.clicks)/nullif(sum(age_gender_report.impressions),0))*100 as daily_ctr,
        sum(age_gender_report.real_time_conversion) as real_time_conversion

        {{ tiktok_ads_persist_pass_through_columns(pass_through_variable='tiktok_ads__campaign_age_gender_report_passthrough_metrics', identifier='age_gender_report', transform='sum', coalesce_with=0) }}

    from age_gender_report
    left join campaigns
        on age_gender_report.campaign_id = campaigns.campaign_id
        and age_gender_report.source_relation = campaigns.source_relation
    left join advertiser
        on campaigns.advertiser_id = advertiser.advertiser_id
        and campaigns.source_relation = advertiser.source_relation

    {{ dbt_utils.group_by(n=18) }}
)

select *
from aggregated
