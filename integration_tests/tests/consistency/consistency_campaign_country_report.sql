{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        campaign_id,
        country_code,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversion) as conversion,
        sum(real_time_conversion) as real_time_conversion
    from {{ target.schema }}_tiktok_ads_prod.tiktok_ads__campaign_country_report
    group by 1, 2
),

dev as (
    select
        campaign_id,
        country_code,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversion) as conversion,
        sum(real_time_conversion) as real_time_conversion
    from {{ target.schema }}_tiktok_ads_dev.tiktok_ads__campaign_country_report
    group by 1, 2
),

final as (
    select
        prod.campaign_id,
        prod.country_code,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend,
        prod.conversion as prod_conversion,
        dev.conversion as dev_conversion,
        prod.real_time_conversion as prod_real_time_conversion,
        dev.real_time_conversion as dev_real_time_conversion
    from prod
    full outer join dev
        on dev.campaign_id = prod.campaign_id
        and dev.country_code = prod.country_code
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    or abs(prod_conversion - dev_conversion) >= .01
    or abs(prod_real_time_conversion - dev_real_time_conversion) >= .01
