{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true) and var('tiktok_ads__using_campaign_age_gender_report', true)) }}

with base as (

    select *
    from {{ ref('stg_tiktok_ads__campaign_age_gender_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_tiktok_ads__campaign_age_gender_report_tmp')),
                staging_columns=get_campaign_age_gender_report_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='tiktok_ads') }}

    from base
),

final as (

    select
        campaign_id,
        cast(stat_time_day as date) as stat_time_day,
        coalesce(age, 'NONE') as age,
        -- TikTok age ranges follow the AGE_<min>_<max> format. Other values, such as NONE, return null.
        case when upper(age) like 'AGE%'
            then cast(nullif({{ dbt.split_part('age', "'_'", 2) }}, '') as {{ dbt.type_int() }})
        end as min_age,
        case when upper(age) like 'AGE%'
            then cast(nullif({{ dbt.split_part('age', "'_'", 3) }}, '') as {{ dbt.type_int() }})
        end as max_age,
        coalesce(gender, 'UNKNOWN') as gender,
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

        {{ tiktok_ads_fill_pass_through_columns(pass_through_fields=var('tiktok_ads__campaign_age_gender_report_passthrough_metrics')) }}

    from fields
)

select *
from final
