{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true) and var('tiktok_ads__using_campaign_country_report', true)) }}

with base as (

    select *
    from {{ ref('stg_tiktok_ads__campaign_country_report_tmp') }}
), 

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_tiktok_ads__campaign_country_report_tmp')),
                staging_columns=get_campaign_country_report_columns()
            )
        }}
    
        {{ fivetran_utils.source_relation(
            union_schema_variable='tiktok_ads_union_schemas', 
            union_database_variable='tiktok_ads_union_databases') 
        }}

    from base
), 

final as (

    select
        campaign_id,
        cast(stat_time_day as date) as stat_time_day,
        country_code,
        coalesce(clicks, 0) as clicks,
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(conversion, 0) as conversion,
        coalesce(conversion_rate, 0) as conversion_rate,
        coalesce(cost_per_conversion, 0) as cost_per_conversion,
        coalesce(cpc, 0) as cpc,
        coalesce(cpm, 0) as cpm,
        coalesce(ctr, 0) as ctr,
        coalesce(real_time_conversion, 0) as real_time_conversion,
        source_relation,
        _fivetran_synced

        {{ tiktok_ads_fill_pass_through_columns(pass_through_fields=var('tiktok_ads__campaign_country_report_passthrough_metrics')) }}

    from fields
)

select *
from final

