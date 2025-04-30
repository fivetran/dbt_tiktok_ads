{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false) and var('tiktok_ads__using_campaign_country_report', true)
) }}

with staging as (
    select 
        campaign_id,
        count(campaign_id) as count_campaign,
        count(distinct stat_time_day) as count_unique_days,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks, 
        sum(spend) as total_spend, 
        sum(conversion) as total_conversion,
    from {{ ref('stg_tiktok_ads__campaign_country_report') }}
    group by 1
),

end_model as (
    select 
        campaign_id,
        count(campaign_id) as count_campaign,
        count(distinct date_day) as count_unique_days,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks, 
        sum(spend) as total_spend, 
        sum(conversion) as total_conversion,
    from {{ ref('tiktok_ads__campaign_country_report') }}
    group by 1
),

combined as (
    select 
        end_model.campaign_id,
        end_model.count_campaign as end_count_campaign,
        staging.count_campaign as staging_count_campaign,
        end_model.count_unique_days as end_count_unique_days,
        staging.count_unique_days as staging_count_unique_days,
        end_model.total_impressions as end_total_impressions,
        staging.total_impressions as staging_total_impressions,
        end_model.total_clicks as end_total_clicks,
        staging.total_clicks as staging_total_clicks,
        end_model.total_spend as end_total_spend,
        staging.total_spend as staging_total_spend,
        end_model.total_conversion as end_total_conversion,
        staging.total_conversion as staging_total_conversion
    from end_model
    full outer join staging
        on end_model.campaign_id = staging.campaign_id
)

select *
from combined
where end_count_campaign != staging_count_campaign or
    end_count_unique_days != staging_count_unique_days or
    end_total_impressions != staging_total_impressions or
    end_total_clicks != staging_total_clicks or
    abs(end_total_spend - staging_total_spend) > 0.01 or 
    end_total_conversion != staging_total_conversion