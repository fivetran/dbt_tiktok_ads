{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true)) }}

with base as (

    select *
    from {{ ref('stg_tiktok_ads__location_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_tiktok_ads__location_tmp')),
                staging_columns=get_location_columns()
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
        source_relation,
        {{ dbt_utils.generate_surrogate_key(['region_id', 'advertiser_id', 'source_relation']) }} as location_id,
        region_id,
        cast(advertiser_id as {{ dbt.type_string() }}) as advertiser_id,
        country_code,
        region_name,
        region_level,
        area_type,
        parent_id,
        support_below_18,
        _fivetran_synced

    from fields

)

select *
from final
