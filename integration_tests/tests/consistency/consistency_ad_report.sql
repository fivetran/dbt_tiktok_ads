{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        ad_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
        {# sum(conversion) as conversion,
        sum(total_conversion_value) as total_conversion_value #}
    from {{ target.schema }}_tiktok_ads_prod.tiktok_ads__ad_report
    group by 1
),

dev as (
    select
        ad_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
        {# sum(conversion) as conversion,
        sum(total_conversion_value) as total_conversion_value #}
    from {{ target.schema }}_tiktok_ads_dev.tiktok_ads__ad_report
    group by 1
),

final as (
    select 
        prod.ad_id,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
        {# prod.conversion as prod_conversion,
        dev.conversion as dev_conversion,
        prod.total_conversion_value as prod_total_conversion_value,
        dev.total_conversion_value as dev_total_conversion_value #}
    from prod
    full outer join dev 
        on dev.ad_id = prod.ad_id
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    {# or abs(prod_conversion - dev_conversion) >= .01
    or abs(prod_total_conversion_value - dev_total_conversion_value) >= .01 #}